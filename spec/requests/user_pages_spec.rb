require 'spec_helper'

describe "User Pages" do

	subject { page }

	describe "signup page" do
		before { visit signup_path }

		it { should have_content('Sign up') }
		it { should have_title(full_title('Sign Up')) }
	end

	describe "profile page" do
		let(:user) { FactoryGirl.create(:user) }
		let(:p1) { FactoryGirl.create(:post, user: user, content: "lalala") }
		let!(:m1) { FactoryGirl.create(:micropost, user: user, post: p1, content: "Foo") }
		let!(:m2) { FactoryGirl.create(:micropost, user: user, post: p1, content: "Bar") }

		before { visit user_path(user) }
		
		it { should have_content(user.firstname + ' ' + user.lastname) }
		it { should have_title(user.firstname + ' ' + user.lastname) }

		describe "microposts" do
			it { should have_content(m1.content) }
			it { should have_content(m2.content) }
			it { should have_content(user.microposts.count) }
		end
	end

	describe "sign up" do
		before { visit signup_path }

		let(:submit) { "Sign Up" }

		describe "with invalid information" do
			it "should not create a user" do
				expect { click_button submit }.not_to change(User, :count)
			end

			describe "after submission" do
				before { click_button submit }

				it { should have_title('Sign Up') }
				it { should have_content('error') }
				it { should have_content('Email is invalid') }
				it { should have_content('Password is too short') }
				it { should have_content('must have at least one capital letter, one lowercase letter, and one number.')}
			end
		end

		describe "with valid information" do
			before do
				fill_in "First Name",		with: "Example"
				fill_in "Last Name",		with: "User"
				fill_in "Email",			with: "user@example.com"
				fill_in "Password",			with: "Foobar123"
				fill_in "Confirm Password",	with: "Foobar123"
			end

			it "should create a user" do
				expect { click_button submit }.to change(User, :count).by(1)
			end

			describe "after saving the user" do
				before { click_button submit }
				let(:user) { User.find_by(email: 'user@example.com') }

				it { should have_link('Sign Out') }
				it { should have_title(user.firstname + ' ' + user.lastname) }
				it { should have_selector('div.alert.alert-success', text: 'Welcome') }

				describe "visiting the sign up page" do
					before { visit signup_path }
					it { should_not have_content('Sign Up') }
					it { should_not have_title('Sign Up') }
				end

				describe "submitting to the create action" do
					before do
						click_link "Sign Out"
						sign_in user, no_capybara: true
						post users_path(user)
					end
					specify { response.should redirect_to(root_url) }
				end
			end
		end
	end

	describe "edit" do
		let(:user) { FactoryGirl.create(:user) }
		before do
			sign_in user
			visit edit_user_path(user)
		end

		describe "page" do
			it { should have_content("Update Your Profile") }
			it { should have_title("Edit User") }
		end

		describe "with invalid information" do
			before { click_button "Save Changes" }

			it { should have_content('error') }
		end

		describe "with valid information" do
			let(:new_firstname) { "New" }
			let(:new_lastname) { "Name" }
			let(:new_email) { "new@example.com" }
			before do
				fill_in "First Name",		with: new_firstname
				fill_in "Last Name",		with: new_lastname
				fill_in "Email",			with: new_email
				fill_in "Password",			with: user.password
				fill_in "Confirm Password",	with: user.password
				click_button "Save Changes"
			end

			it { should have_title(new_firstname + ' ' + new_lastname) }
			it { should have_selector('div.alert.alert-success') }
			it { should have_link('Sign Out', href: signout_path) }
			specify { expect(user.reload.firstname).to  eq new_firstname }
			specify { expect(user.reload.lastname).to  eq new_lastname }
			specify { expect(user.reload.email).to eq new_email }
		end
	end

	describe "index" do

		let(:user) { FactoryGirl.create(:user) }

		before do
			sign_in user
			visit users_path
		end

		it { should have_title('Users') }
		it { should have_content('Users') }

		describe "pagination" do
			before(:all) { 30.times { FactoryGirl.create(:user) } }
			after(:all) { User.delete_all }

			it { should have_selector('div.pagination') }

			it "should list each user" do
				User.paginate(page: 1).each do |user|
					expect(page).to have_selector('li', text: user.firstname + ' ' + user.lastname)
				end
			end
		end

		describe "delete links" do
			it { should_not have_link('delete') }

			describe "as an admin user" do
				let(:admin) { FactoryGirl.create(:admin) }
				before do
					sign_in admin
					visit users_path
				end

				it { should have_link('delete', href: user_path(User.first)) }
				it "should be able to delete another user" do
					expect do
						click_link('delete', match: :first)
					end.to change(User, :count).by(-1)
				end
				it { should_not have_link('delete', href: user_path(admin)) }
			end
		end
	end
end








