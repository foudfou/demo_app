# == Schema Information
# Schema version: 20110217231907
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean
#
require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation
  # NOTE: don't add :admin to attr_accessible which would allow 'put /users/17?admin=1'

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  :presence => true,
                    :length   => { :maximum => 50 }
  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
  # needs also DB index in case validations gets passed twice before writting
  # to DB. use this in Controller#create:
  # rescue ActiveRecord::StatementInvalid
  #   # Handle duplicate email addresses gracefully by redirecting.
  #   redirect_to home_url
  # Automatically create the virtual attribute 'password_confirmation'.
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 },
                       :if           => :password_required?

  before_save :encrypt_password

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  private

  def encrypt_password
    self.salt = make_salt if new_record?
    # NOTE: 'self' required, otherwise would create a local variable
    self.encrypted_password = encrypt(password)
  end

  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end

  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end

  def password_required?
    !(persisted? && password.nil? && password_confirmation.nil?)
  end

end
