class Post < ActiveRecord::Base
	belongs_to :user
	has_many :microposts, dependent: :destroy

	default_scope -> { order('created_at DESC') }
	validates :user_id, presence: true
	validates :title, presence: true, length: { maximum: 50 }
	validates :content, presence: true, length: { maximum: 500 }
end