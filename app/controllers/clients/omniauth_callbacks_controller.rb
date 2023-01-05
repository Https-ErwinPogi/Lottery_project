# frozen_string_literal: true

class Clients::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.create_from_provider_data(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in :user, @user
      redirect_to clients_root_path
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    else
      flash[:alert] = @user.errors.full_messages.join(', ')
      redirect_to new_user_registration_url
    end
  end

  def google_oauth2
    @user = User.create_from_provider_data(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in :user, @user
      redirect_to clients_root_path
      set_flash_message(:notice, :success, kind: 'Google') if is_navigational_format?
    else
      flash[:alert] = @user.errors.full_messages.join(', ')
      redirect_to new_user_registration_url
    end
  end

  def failure
    flash[:alert] = @user.errors.full_messages.join(', ')
    redirect_to new_user_registration_url
  end

  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
