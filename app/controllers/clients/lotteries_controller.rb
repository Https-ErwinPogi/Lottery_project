class Clients::LotteriesController < ApplicationController
  def index
    @items = Item.active.starting
    @items = @items.includes(:categories).where(categories: { name: params[:category_name] }) if params[:category_name]
    @categories = Category.all
  end
end
