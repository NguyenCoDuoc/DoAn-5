class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
<<<<<<< HEAD
     if user
        log_in user
        params[:session][:remember_me] == "1" ? remember(user) : forget(user)
        redirect_back_or user
      else
        message = "Account not activated."
        message += "Check your email for the activation link." 
        flash[:warning]=message
        redirect_to root_url
      end
    else
      #login facebook
      begin
        user = User.from_omiauth(request.env['omniauth.auth'])
        session[:user_id] = user_id
        flash[:success] = "Welcome, #{user.email}!"
      rescue
        flash[:warning] = "There was am error while trying to authentiace you..."
      end
      redirect_to root_path
=======
      log_in user
      redirect_to root_url
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
>>>>>>> doan5
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end

def failure
  render :text => "Sorry, but you didn't access to our app!"
end