class MicropostsController < ApplicationController
	before_action :signed_in_user,	only: [:create, :destroy]
	before_action :correct_user,	only: :destroy

	def create
		@post = Post.find(params[:post_id])
		@micropost = @post.microposts.create(micropost_params)
		@micropost.user = current_user
		if @micropost.save
			flash[:success] = "Response submitted."
			redirect_to post_path(@post)
		else
			@microposts = @post.microposts.paginate(page: params[:page])
			render 'posts/show'
		end
	end

	def destroy
		@micropost.destroy
		redirect_to root_url
	end

	private

	def micropost_params
		params.require(:micropost).permit(:content)
	end

	def correct_user
		if current_user.admin?
			@micropost = Micropost.find(params[:id])
		else
			@micropost = current_user.microposts.find_by(id: params[:id])
		end
		redirect_to root_url if @micropost.nil?
	end
end