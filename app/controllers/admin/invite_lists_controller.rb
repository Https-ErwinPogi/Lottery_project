class Admin::InviteListsController < AdminController
  def index
    @users = User.includes(:parent, :children, :bets).client.where.not(parent: nil)
    @users = @users.where(parent: { email: params[:parent_email] }) if params[:parent_email].present?
  end
end
