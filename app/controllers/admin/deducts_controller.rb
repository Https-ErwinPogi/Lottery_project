class Admin::DeductsController < AdminController
  def new
    @user = User.find(params[:user_id])
    @order = Order.new
  end

  def create
    @order = Order.new(params.require(:order).permit(:coin, :remarks))
    @order.user = User.find(params[:user_id])
    @order.state = :submitted
    @order.genre = :deduct
    if @order.save && @order.may_pay?
      @order.pay!
      flash[:notice] = "Successfully deducted"
      redirect_to new_admin_user_deduct_path
    elsif @order.cancel!
      flash[:alert] = 'The user have not enough coins to deduct'
      redirect_to new_admin_user_deduct_path
    else
      flash[:alert] = @order.errors.full_messages.join(', ')
      redirect_to new_admin_user_deduct_path
    end
  end
end
