class Admin::BonusesController < AdminController
  def new
    @user = User.find(params[:user_id])
    @order = Order.new
  end

  def create
    @order = Order.new(params.require(:order).permit(:coin, :remarks))
    @order.user = User.find(params[:user_id])
    @order.state = :submitted
    @order.genre = :bonus
    if @order.save && @order.may_pay?
      @order.pay!
      flash[:notice] = "Bonus successfully added to user coins"
      redirect_to new_admin_user_bonuse_path
    else
      flash[:alert] = @order.errors.full_messages.join(', ')
      redirect_to new_admin_user_bonuse_path
    end
  end
end
