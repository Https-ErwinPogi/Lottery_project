class Clients::ShopsController < ApplicationController
  before_action :authenticate_user!, only: :create

  def index
    @offers = Offer.active
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @offer = Offer.active.find(params[:order][:offer_id])
    @order.user = current_user
    @order.amount = @offer.amount
    @order.coin = @offer.coin
    @order.genre = :deposit
    @order.state = :submitted
    if @order.save
      flash[:notice] = "Order successfully"
      redirect_to clients_shops_path
    else
      flash[:alert] = "Order unsuccessful"
      render :index
    end
  end

  private

  def order_params
    params.require(:order).permit(:offer_id)
  end
end
