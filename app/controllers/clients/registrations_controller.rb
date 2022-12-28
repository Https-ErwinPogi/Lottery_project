# frozen_string_literal: true

class Clients::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    super
    unless cookies[:promoter]
      cookies[:promoter] = params[:promoter]
    end
  end

  # POST /resource
  def create
    params[:user][:parent_id] = User.find_by_email(cookies[:promoter])&.id
    super
  end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    parameter = params[:user]
    if parameter[:password]&.present? || parameter[:password_confirmation]&.present? || parameter[:current_password]&.present?
      update_password
    elsif params[:user][:current_password].blank?
      user_update
    else
      render :edit
    end
  end

  protected

  def user_update
    if resource.update_without_password(user_params.except(:current_password))
      redirect_to clients_profiles_path
    else
      render :edit
    end
  end

  def update_password
    if resource.update_with_password(user_password_params)
      redirect_to clients_profiles_path
    else
      render :edit
    end
  end

  def user_params
    params.require(:user).permit(:phone, :username, :image)
  end

  def user_password_params
    params.require(:user).permit(:phone, :username, :image, :password, :password_confirmation, :current_password)
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:parent_id, :email, :password, :password_confirmation])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
