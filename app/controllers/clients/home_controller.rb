class Clients::HomeController < ApplicationController
  def index
    @winners = Winner.published.limit(5)
    @items = Item.active.starting.limit(5)
  end
end