class Clients::OrdersController < ApplicationController
  def cancel
    @order = Order.find(params[:order_id])
    if @order.cancel!
      redirect_to clients_profiles_path
      flash[:notice] = "The order has been cancelled"
    else
      redirect_to clients_profiles_path
      flash[:alert] = @order.errors.full_messages.join(', ')
    end
  end
end
