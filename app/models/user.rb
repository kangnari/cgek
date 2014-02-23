class User < ActiveRecord::Base
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	VALID_PASSWORD_REGEX = /\A(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).*\z/

	has_many :posts, dependent: :destroy
	has_many :microposts, dependent: :destroy
	before_save { email.downcase! }
	before_create :create_remember_token	
	validates :firstname, presence: true, length: { maximum: 25 }
	validates :lastname, presence: true, length: { maximum: 25 }
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
					  uniqueness: { case_sensitive: false }
	has_secure_password
	validates :password, length: { minimum: 6 }, format: { with: VALID_PASSWORD_REGEX, message: "must have at least one capital letter, one lowercase letter, and one number."}
	has_attached_file :image, :styles => { :profile => "100x100", :index => "75x75", :thumb => "50x50" }

	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.encrypt(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	private
		def create_remember_token
			self.remember_token = User.encrypt(User.new_remember_token)
		end
end
