class User < ActiveRecord::Base
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	VALID_PASSWORD_REGEX = /\A(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).*\z/

	before_save { email.downcase! }
	validates :firstname, presence: true, length: { maximum: 25 }
	validates :lastname, presence: true, length: { maximum: 25 }
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
					  uniqueness: { case_sensitive: false }
	has_secure_password
	validates :password, length: { minimum: 6 }, format: { with: VALID_PASSWORD_REGEX, message: "must have at least one capital letter, one lowercase letter, and one number."}
end
