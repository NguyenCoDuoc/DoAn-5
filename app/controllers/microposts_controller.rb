class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    if @micropost.save
      redirect_back(fallback_location: root_path)
    else
      @feed_items = []
      redirect_back(fallback_location: root_path)
      flash[:danger] = "Post fails"
    end
  end

  def destroy
    if @micropost.destroy
      render json: {status: :success}
    else
      render json: {status: :error, message: "Delete fails"}
    end
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :picture
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    redirect_to root_url unless @micropost
  end
end
