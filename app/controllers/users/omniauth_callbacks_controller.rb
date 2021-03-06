# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def all
      auth_data = request.env['omniauth.auth']
      @user = User.from_omniauth(auth_data)

      process_request(auth_data)
    end

    alias facebook all
    alias google all

    private

    def process_request(auth_data)
      provider = auth_data.provider

      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        if is_navigational_format?
          set_flash_message(:notice, :success, kind: provider.capitalize)
        end
      else
        session["devise.#{provider}_data"] = auth_data
        redirect_to new_user_registration_url
      end
    end
  end
end
