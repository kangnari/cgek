require 'spec_helper'

describe "Authentication" do
	subject { page }

	describe "signin page" do
		before { visit signin_path }

		it { should have_content('Sign In') }
		it { should have_title('Sign In') }
	end

	describe "signin" do
		before { visit signin_path }

		describe "with invalid information" do
			before { click_button "Sign In" }

			it { should have_title('Sign In') }
			it { should have_selector('div.alert.alert-error') }

			describe "after visiting another page" do
				before { click_link "Home" }
				it { should_not have_selector('div.alert.alert-error') }
			end
		end

		describe "with valid information" do
			let(:user) { FactoryGirl.create(:user) }
			before { sign_in user }

			it { should have_title(user.firstname + ' ' + user.lastname) }
			it { should have_link('Users',       href: users_path) }
			it { should have_link('Profile',		href: user_path(user)) }
			it { should have_link('Settings',		href: edit_user_path(user)) }
			it { should have_link('Sign Out',		href: signout_path) }
			it { should_not have_link('Sign In',	href: signin_path) }

			describe "followed by signout" do
				before { click_link "Sign Out" }
				it { should have_link('Sign In') }
			end
		end
	end

	describe "authorization" do
		describe "for non-signed-in users" do
			let(:user) { FactoryGirl.create(:user) }

			describe "in the Users controller" do
				before { visit edit_user_path(user) }
				it { should have_title('Sign In') }

				describe "visiting the user index" do
					before { visit users_path }
					it { should have_title('Sign In') }
				end
			end

			describe "in the Posts controller" do
				describe "submitting to the create action" do
					before { post posts_path }
					specify { expect(response).to redirect_to(signin_path) }
				end

				describe "submitting to the destroy action" do
					before { delete post_path(FactoryGirl.create(:post)) }
					specify { expect(response).to redirect_to(signin_path) }
				end

				describe "submitting to the show action" do
					before do
						@p1 = Post.create(user: user, title: "a title", content: "lalala" )
						visit post_path(@p1)
					end
					it { should have_title("a title") }
					it { should have_content("lalala") }
				end
			end

			describe "submitting to the update action" do
				before { patch user_path(user) }
				specify { expect(response).to redirect_to(signin_path) }
			end

			describe "when attempting to visit a protected page" do
				before do
					visit edit_user_path(user)
					fill_in "Email",    with: user.email
					fill_in "Password", with: user.password
					click_button "Sign In"
				end

				describe "after signing in" do
					it "should render the desired protected page" do
						expect(page).to have_title('Edit User')
					end
				end
			end
		end

		describe "as wrong user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
			before { sign_in user, no_capybara: true }

			describe "submitting a GET request to the Users#edit action" do
				before { get edit_user_path(wrong_user) }
				specify { expect(response.body).not_to match(full_title('Edit User')) }
				specify { expect(response).to redirect_to(root_url)}
			end

			describe "submitting a PATCH request to the Users#update action" do
				before { patch user_path(wrong_user) }
				specify { expect(response).to redirect_to(root_url) }
			end
		end

		describe "as non-admin user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:non_admin) { FactoryGirl.create(:user) }

			before { sign_in non_admin, no_capybara: true }

			describe "submitting a DELETE request to the Users#destroy action" do
				before { delete user_path(user) }
				specify { expect(response).to redirect_to(root_url) }
			end
		end
	end
end





