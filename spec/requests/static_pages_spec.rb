require 'spec_helper'

describe "StaticPages" do
	describe "Home page" do
		it "should have content 'CGEK' " do
			visit root_path
			expect(page).to have_content('CGEK')
		end
	end
end
