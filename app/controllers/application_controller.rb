class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  before_action :set_i18n_locale
<<<<<<< HEAD
=======

   protect_from_forgery with: :exception

>>>>>>> doan5

  private

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t ".please_log_in"
    redirect_to login_url
  end
  def set_i18n_locale 
        if params[:locale] 
            if I18n.available_locales.include?(params[:locale].to_sym)
                I18n.locale = params[:locale] 
            else
                flash.now[:notice] = params[:locale] + ' is not supported'              
            end
        end
    end
  
    def default_url_options 
        { :locale => I18n.locale }
    end
<<<<<<< HEAD
=======
    
>>>>>>> doan5
end
