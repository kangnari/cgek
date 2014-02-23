FactoryGirl.define do
	factory :user do
		sequence(:firstname)	{ |n| "Person #{n}" }
		sequence(:lastname)		{ |n| "Person #{n}" }
		sequence(:email)		{ |n| "person_#{n}@example.com"}
		password				"Foobar123"
		password_confirmation	"Foobar123"

		factory :admin do
			admin true
		end
	end

	factory :micropost do
		content "Lorem ipsum"
		user
		post
	end

	factory :post do
		content "Lorem ipsum"
		title "Lorem ipsum"
		user
	end
end