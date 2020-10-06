class Dog < ApplicationRecord
  has_many_attached :images
  has_many :likes, dependent: :destroy

  # belongs to is optional, so seeds still work. plus some dogs don't have owners :(.
  belongs_to :owner, class_name: :User, optional: true

  def self.sort_by_recent_likes
    Dog.all.sort_by{|dog| -dog.recent_likes}
  end
  
  def recent_likes
    Like.where(dog_id: id, created_at: 1.hours.ago..Time.now).count
  end
end
