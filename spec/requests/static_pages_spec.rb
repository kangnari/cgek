require 'spec_helper'

describe "StaticPages" do
	let(:base_title) { "CGEK" }
	describe "Home page" do
		it "should have content 'CGEK' " do
			visit root_path
			expect(page).to have_content('CGEK')
		end

		it "should have the base title" do
			visit root_path
			expect(page).to have_title("CGEK")
		end

		it "should not have a custom page title" do
			visit root_path
			expect(page).not_to have_title('Home - ')
		end
	end
end
