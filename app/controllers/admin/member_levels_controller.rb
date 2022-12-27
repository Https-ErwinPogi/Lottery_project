class Admin::MemberLevelsController < AdminController
  def new
    @user = User.find(params[:user_id])
    @order = Order.new
  end

  def create
    @order = Order.new(params.require(:order).permit(:coin))
    @order.user = User.find(params[:user_id])
    @order.state = :submitted
    @order.genre = :member_level
    if @order.save && @order.may_pay?
      @order.pay!
      flash[:notice] = "Member level successfully added to user coins"
      redirect_to new_admin_user_member_level_path
    else
      flash[:alert] = @order.errors.full_messages.join(', ')
    end
  end
end
