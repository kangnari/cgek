class PostsController < ApplicationController
	before_action :signed_in_user, only: [:create, :destroy]
	before_action :correct_user, only: :destroy

	def create
		@post = current_user.posts.build(post_params)
		if @post.save
			flash[:success] = "Post created."
			redirect_to root_url
		else
			@posts = Post.paginate(page: params[:page])
			render 'static_pages/home'
		end
	end

	def destroy
		@post.destroy
		redirect_to root_url
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

		def correct_user
			@post = current_user.posts.find_by(id: params[:id])
			redirect_to root_url if @post.nil?
		end
end