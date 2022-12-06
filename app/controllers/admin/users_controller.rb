class Admin::UsersController < AdminController
  def index
    @users = User.where(role: 0)
  end
end