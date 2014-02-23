class MicropostsController < ApplicationController
	before_action :signed_in_user

	def create
		@post = Post.find(params[:post_id])
		@micropost = @post.microposts.create(micropost_params)
		@micropost.user = User.find(current_user.id)
		if @micropost.save
			flash[:success] = "Response submitted."
			redirect_to post_path(@post)
		else
			@microposts = @post.microposts.paginate(page: params[:page])
			render 'posts/show'
		end
	end

	def destroy
	end

	private

	def micropost_params
		params.require(:micropost).permit(:content)
	end
end