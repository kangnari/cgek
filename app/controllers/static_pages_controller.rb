class StaticPagesController < ApplicationController
	def home
		@post = current_user.posts.build if signed_in?
		@posts = Post.paginate(page: params[:page])
	end
end
