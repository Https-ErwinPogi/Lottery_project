class Clients::LotteriesController < ApplicationController
  before_action :set_item, only: :create
  before_action :authenticate_user!, only: :create

  def index
    @items = Item.active.starting
    @items = @items.includes(:categories).where(categories: { name: params[:category_name] }) if params[:category_name]
    @categories = Category.all
  end

  def show
    @item = Item.find(params[:id])
    @current_bets = @item.bets.where(user: current_user, batch_count: @item.batch_count, item: @item)
    @bet = Bet.new
  end

  def create
    count = params[:bet][:coins].to_i
    if current_user.coins >= count
      count = params[:bet][:coins].to_i
      params[:bet][:coins] = 1
      params[:bet][:item_id] = @item.id
      count.times {
        @bet = Bet.new(bet_params)
        @bet.user = current_user
        @bet.batch_count = @item.batch_count
        @bet.save!
      }
      flash[:notice] = "Successfully Bet!"
      redirect_to clients_lottery_path(@item)
    else
      flash[:alert] = "You don't have enough coins to place your selected bet. Current coin/s #{current_user.coins}"
      redirect_to clients_shops_path
    end
  end

  private

  def bet_params
    params.require(:bet).permit(:item_id, :coins)
  end

  def set_item
    @item = Item.find(params[:bet][:item_id])
  end
end