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
		users = User.all(limit: 6)
		50.times do
			title = Faker::Lorem.sentence(1)
			content = Faker::Lorem.sentence(5)
			users.each do |user|
				post = Post.create!(user: user, title: title, content: content)
				user.microposts.create!(content: content, post: post)
			end
		end
	end
end