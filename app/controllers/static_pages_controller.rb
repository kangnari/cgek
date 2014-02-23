class StaticPagesController < ApplicationController
	def home
		@post = current_user.posts.build if signed_in?
	end
end
