class Admin::BetsController < AdminController
  before_action :set_bet_event, only: :cancel
  require 'csv'

  def index
    @bets = Bet.includes(:item, :user).all
    @bets = @bets.where(serial_number: params[:serial_number]) if params[:serial_number].present?
    @bets = @bets.where(item: { name: params[:item_name] }) if params[:item_name].present?
    @bets = @bets.where(user: { email: params[:user_email] }) if params[:user_email].present?
    @bets = @bets.where(state: params[:state]) if params[:state].present?
    @bets = @bets.where('created_at >= ?', params[:start]) if params[:start].present?
    @bets = @bets.where('created_at <= ?', params[:end]) if params[:end].present?
    respond_to do |format|
      format.html
      format.csv {
        csv_string = CSV.generate do |csv|
          csv << [Bet.human_attribute_name(:serial_number),
                  Bet.human_attribute_name(:item_name),
                  Bet.human_attribute_name(:email),
                  Bet.human_attribute_name(:state),
                  Bet.human_attribute_name(:created_at)]
          @bets.each do |bet|
            csv << [bet.serial_number,
                    bet.item.name,
                    bet.user.email,
                    bet.state,
                    bet.created_at]
          end
        end
        render plain: csv_string
      }
    end
  end

  def cancel
    if @bet.may_cancel?
      @bet.cancel!
      redirect_to admin_bets_path
    else
      flash[:alert] = 'Bets cant be cancel'
      redirect_to admin_bets_path
    end
  end

  private

  def set_bet_event
    @bet = Bet.find(params[:bet_id])
  end
end
