class Admin::OrdersController < AdminController
  before_action :set_event_order, only: [:pay, :cancel]

  def index
    @orders = Order.includes(:user, :offer)
    @total_coins = @orders.sum(:coin)
    @total_amount = @orders.sum(:amount)
    @orders = @orders.where(serial_number: params[:serial_number]) if params[:serial_number].present?
    @orders = @orders.where(user: { email: params[:user_email] }) if params[:user_email].present?
    @orders = @orders.where(genre: params[:genre]) if params[:genre].present?
    @orders = @orders.where(state: params[:state]) if params[:state].present?
    @orders = @orders.where(offer: params[:offer]) if params[:offer].present?
    @orders = @orders.where('created_at >= ?', params[:start]) if params[:start].present?
    @orders = @orders.where('created_at <= ?', params[:end]) if params[:end].present?
    @subtotal_coin = @orders.sum(:coin)
    @subtotal_amount = @orders.sum(:amount)
  end

  def pay
    if @order.may_pay?
      begin
        @order.pay!
        redirect_to admin_orders_path
        flash[:notice] = "Successfully Cancelled"
      rescue ActiveRecord::RecordInvalid => order_exception
        flash[:alert] = order_exception
        redirect_to admin_orders_path
      end
    end
  end

  def cancel
    if @order.may_cancel?
      begin
        @order.cancel!
        redirect_to admin_orders_path
        flash[:notice] = "Successfully Cancelled"
      rescue ActiveRecord::RecordInvalid => exception
        flash[:alert] = exception
        redirect_to admin_orders_path
      end
    end
  end

  private

  def set_event_order
    @order = Order.find(params[:order_id])
  end
end
