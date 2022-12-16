class Clients::ProfilesController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @orders = Order.where(user: @user) if params[:history] == 'order'
    @bets = Bet.includes(:item).where(user: @user) if params[:history] == 'bet'
    @invites = User.where(parent: @user) if params[:history] == 'invite'
    @winners = Winner.where(user: @user) if params[:history] == 'winner'
  end
end