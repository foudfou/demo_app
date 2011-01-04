# == Schema Information
# Schema version: 20110103180626
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  attr_accessible :name, :email

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
end
