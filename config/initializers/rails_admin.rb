RailsAdmin.config do |config|
      config.authenticate_with do
        warden.authenticate! scope: :admin
      end
      config.current_user_method(&:current_admin)
    end