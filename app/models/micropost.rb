class Micropost < ActiveRecord::Base
	belongs_to :user
	belongs_to :post
	
	default_scope -> { order('created_at DESC') }
	validates :user_id, presence: true
	validates :post_id, presence: true
	validates :content, presence: true, length: { maximum: 500 }
end
