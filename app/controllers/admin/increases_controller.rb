class Admin::IncreasesController < AdminController
  def new
    @user = User.find(params[:user_id])
    @order = Order.new
  end

  def create
    @order = Order.new(params.require(:order).permit(:coin, :remarks))
    @order.user = User.find(params[:user_id])
    @order.state = :submitted
    @order.genre = :increase
    if @order.save && @order.may_pay?
      @order.pay!
      flash[:notice] = "Order successfully"
      redirect_to new_admin_user_increase_path
    else
      redirect_to new_admin_user_increase_path
      flash[:alert] = @order.errors.full_messages.join(', ')
    end
  end
end
