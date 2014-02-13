require 'spec_helper'

describe User do

	before do
		@user = User.new(firstname: "Example", lastname: "User", email: "user@example.com",
							  password: "Foobar123", password_confirmation: "Foobar123")
	end

	subject { @user }

	it { should respond_to(:firstname) }
	it { should respond_to(:lastname) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:authenticate) }
	it { should respond_to(:image) }

	it { should be_valid }

	describe "testing name attributes" do
		describe "when firstname is not present" do
			before { @user.firstname = " " }
			it { should_not be_valid }
		end

		describe "when lastname is not present" do
			before { @user.lastname = " " }
			it { should_not be_valid }
		end

		describe "when firstname is too long" do
			before { @user.firstname = "a"*26 }
			it { should_not be_valid}
		end

		describe "when lastname is too long" do
			before { @user.lastname = "a"*26 }
			it { should_not be_valid }
		end
	end

	describe "testing email attribtues" do
		describe "when email is not present" do
			before { @user.email = " " }
			it { should_not be_valid }
		end

		describe "when format is invalid" do
			it "should be invalid" do
				addresses = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com]
				addresses.each do |invalid_address|
					@user.email = invalid_address
					expect(@user).not_to be_valid
				end
			end
		end

		describe "when format is valid" do
			it "should be valid" do
				addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
				addresses.each do |valid_address|
					@user.email = valid_address
					expect(@user).to be_valid
				end
			end
		end

		describe "when address is already taken" do
			before do
				user_with_same_email = @user.dup
				user_with_same_email.email = @user.email.upcase
				user_with_same_email.save
			end

			it { should_not be_valid }
		end

		describe "when email address has mixed case" do
			let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

			it "should be saved as all lower-case" do
				@user.email = mixed_case_email
				@user.save
				expect(@user.reload.email).to eq mixed_case_email.downcase
			end
		end
	end

	describe "testing password attributes" do
		describe "when password is not present" do
			before do
				@user = User.new(firstname: "Example", lastname: "User", email: "user@example.com",
								 password: " ", password_confirmation: " ")
			end
			it { should_not be_valid }
		end

		describe "when password doesn't match confirmation" do
			before { @user.password_confirmation = "mismatch" }
			it { should_not be_valid }
		end

		describe "when password is invalid" do
			describe "with a password that is too short" do
				before { @user.password = @user.password_confirmation = "Aaaa1" }
				it { should_not be_valid }
			end

			describe "with a password without an upper case" do
				before { @user.password = @user.password_confirmation = "a"*7 + "1" }
				it { should_not be_valid }
			end

			describe "with a password without a lower case" do
				before { @user.password = @user.password_confirmation = "A"*7 + "1" }
				it { should_not be_valid }
			end

			describe "with a password without a number" do
				before { @user.password = @user.password_confirmation = "A"*7 + "a" }
				it { should_not be_valid }
			end
		end

		describe "return value of authenticate method" do
			before { @user.save }
			let(:found_user) { User.find_by(email: @user.email)}

			describe "with valid password" do
				it { should eq found_user.authenticate(@user.password) }
			end

			describe "with invalid password" do
				let(:user_for_invalid_password) { found_user.authenticate("invalid") }

				it { should_not eq user_for_invalid_password }
				specify { expect(user_for_invalid_password).to be_false }
			end
		end
	end
end










