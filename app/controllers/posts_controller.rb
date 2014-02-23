class PostsController < ApplicationController
	before_action :signed_in_user, only: [:create, :destroy]

	def create
		@post = current_user.posts.build(post_params)
		if @post.save
			flash[:success] = "Post created."
			redirect_to @post
		else
			render 'static_pages/home'
		end
	end

	def destroy
	end

	def show
		@post = Post.find(params[:id])
		@micropost = @post.microposts.build
		@microposts = @post.microposts.paginate(page: params[:page])
	end

	private

		def post_params
			params.require(:post).permit(:title, :content)
		end
end