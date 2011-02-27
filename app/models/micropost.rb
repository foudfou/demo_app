class Micropost < ActiveRecord::Base
  attr_accessible :content
  # we don't user_id to be accessible => Microposts can only be created through
  # Users: user.microposts.create

  belongs_to :user

  validates :content, :presence => true, :length => { :maximum => 140 }
  validates :user_id, :presence => true

  default_scope :order => 'microposts.created_at DESC'
end
