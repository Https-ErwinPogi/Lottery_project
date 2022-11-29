class ApplicationController < ActionController::Base
  def after_sign_up_path_for(resource)
    after_sign_in_path_for(resource) if is_navigational_format?
  end

  # def after_sign_in_path_for(resource)
  #   if current_user.admin?
  #     admin_users_path
  #   else
  #     clients_home_index_path
  #   end
  # end
end