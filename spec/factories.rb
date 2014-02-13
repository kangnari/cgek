FactoryGirl.define do
	factory :user do
		firstname				"Example"
		lastname				"User"
		email					"user@example.com"
		password				"Foobar123"
		password_confirmation	"Foobar123"
	end
end