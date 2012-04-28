class Micropost < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user
  
  default_scope order: "microposts.created_at DESC"
  
  scope :from_users_followed_by, lambda {|user| followed_by(user)}
  
  
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  
private
  
  def self.followed_by(user)
    sql_filter = %(SELECT followed_id FROM Relationships 
                   WHERE follower_id = :user_id)
    where("user_id IN (#{sql_filter}) OR user_id = :user_id", {user_id: user.id})
  end
  
end
