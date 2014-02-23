require 'spec_helper'

describe "MicropostPages" do
	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	let(:post) { FactoryGirl.create(:post, user: user) }
	before { sign_in user }

	describe "micropost creation" do
		before { visit post_url(post) }

		describe "with invalid information" do

			it "should not create a micropost" do
				expect { click_button "Respond" }.not_to change(Micropost, :count)
			end

			describe "error messages" do
				before { click_button "Respond" }
				it { should have_content('error') }
			end
		end

		describe "with valid information" do
			before { fill_in 'micropost_content', with: "Lorem ipsum" }
			it "should create a micropost" do
				expect { click_button "Respond" }.to change(Micropost, :count).by(1)
			end
		end
	end
end