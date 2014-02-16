namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		User.create!(firstname: "Example",
					 lastname: "User",
					 email: "example@railstutorial.org",
					 password: "Foobar1",
					 password_confirmation: "Foobar1",
					 admin: true)
		99.times do |n|
			firstname  = Faker::Name.name
			lastname = Faker::Name.name
			email = "example-#{n+1}@railstutorial.org"
			password  = "Password1"
			User.create!(firstname: firstname,
						 lastname: lastname,
						 email: email,
						 password: password,
						 password_confirmation: password)
		end
	end
end