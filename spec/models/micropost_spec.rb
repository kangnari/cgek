require 'spec_helper'

describe Micropost do
	let(:user) { FactoryGirl.create(:user) }
	let(:post) { FactoryGirl.create(:post, user: user) }
	let(:micropost) { FactoryGirl.create(:micropost, user: user, post: post)}

	subject { micropost }

	it { should respond_to(:content) }
	it { should respond_to(:user_id) }
	it { should respond_to(:post_id) }
	it { should respond_to(:user) }
	it { should respond_to(:post) }
	its(:user) { should eq user }
	its(:post) { should eq post }

	it { should be_valid }

	describe "when user_id is not present" do
		before { micropost.user_id = nil }
		it { should_not be_valid }
	end

	describe "when post_id is not present" do
		before { micropost.post_id = nil }
		it { should_not be_valid }
	end

	describe "with blank content" do
		before { micropost.content = " " }
		it { should_not be_valid }
	end

	describe "with content that is too long" do
		before { micropost.content = "a" * 151 }
		it { should_not be_valid }
	end
end
