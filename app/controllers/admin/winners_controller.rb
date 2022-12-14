class Admin::WinnersController < AdminController
  before_action :set_winner_event, only: [:submit, :ship, :pay, :deliver, :publish, :remove_publish]

  def index
    @winners = Winner.includes(:item, :bet, :user, :address)
    @winners = @winners.includes(:bet).where(bet: { serial_number: params[:serial_number] }) if params[:serial_number].present?
    @winners = @winners.where(user: { email: params[:user_email] }) if params[:user_email].present?
    @winners = @winners.where(item: { name: params[:item_name] }) if params[:item_name].present?
    @winners = @winners.where(state: params[:state]) if params[:state].present?
    @winners = @winners.where('created_at >= ?', params[:start]) if params[:start].present?
    @winners = @winners.where('created_at <= ?', params[:end]) if params[:end].present?
  end

  def submit
    if @winner.submit!
      redirect_to admin_winners_path
    else
      flash[:alert] = "You can't claim the item, there might have been unmeet conditions in the items"
      redirect_to admin_winners_path
    end
  end

  def pay
    if @winner.pay!
      redirect_to admin_winners_path
    else
      flash[:alert] = "You can't claim the item, there might have been unmeet conditions in the items"
      redirect_to admin_winners_path
    end
  end

  def ship
    if @winner.ship!
      redirect_to admin_winners_path
    else
      flash[:alert] = "You can't claim the item, there might have been unmeet conditions in the items"
      redirect_to admin_winners_path
    end
  end

  def deliver
    if @winner.deliver!
      redirect_to admin_winners_path
    else
      flash[:alert] = "You can't claim the item, there might have been unmeet conditions in the items"
      redirect_to admin_winners_path
    end
  end

  def publish
    if @winner.publish!
      redirect_to admin_winners_path
    else
      flash[:alert] = "You can't claim the item, there might have been unmeet conditions in the items"
      redirect_to admin_winners_path
    end
  end

  def remove_publish
    if @winner.remove_publish!
      redirect_to admin_winners_path
    else
      flash[:alert] = "You can't claim the item, there might have been unmeet conditions in the items"
      redirect_to admin_winners_path
    end
  end

  private

  def set_winner_event
    @winner = Winner.find(params[:winner_id])
  end
end
