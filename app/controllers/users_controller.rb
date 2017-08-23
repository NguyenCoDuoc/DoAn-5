class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :load_user, except: [:index, :new, :create]

  

  def index
       @users = User.select(:id, :name, :email, :created_at).order(created_at: :desc)
      .paginate page: params[:page], per_page: Settings.user.users_per_page

     

      if params[:term]
        @users = User.search_by_full_name(params[:term])
      else
        @users = User.all
      end

      @current_user = User.find_by id: params[:id]
      return @current_user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      # flash[:success] = "Please check your email address for activate your account."
      flash[:success]= "Welcome to UTEHY"
      render json: {status: :success, redirect_to: root_url}
    else
      render 'new'
    end
  end

  def show
    @microposts = @user.microposts.paginate page: params[:page],
      per_page: Settings.user.users_per_page
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".user_deleted"
    else
      flash[:danger] = t ".you_can_not_delete"
    end
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate page: params[:page],
      per_page: Settings.user.users_per_page
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate page: params[:page],
      per_page: Settings.user.users_per_page
    render 'show_follow'
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def correct_user
    @user = User.find_by id: params[:id]

    return if @user.is_user? current_user
    redirect_to root_url
    flash[:danger] = t ".you_have_not_access"
  end

  def admin_user
    redirect_to root_url unless current_user.is_admin?
  end

  def load_user
    @user = User.find_by id: params[:id]

    return if @user
    flash[:danger] = t(".note") << params[:id]
    redirect_to signup_path
  end
end
