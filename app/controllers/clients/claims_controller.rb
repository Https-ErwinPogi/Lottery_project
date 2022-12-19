class Clients::ClaimsController < ApplicationController
  def show
    @user = current_user
    @winner = Winner.includes(:item, :bet, :address).where(user: @user).find(params[:id])
    @addresses = Address.where(user: @user)
  end

  def update
    @winner = Winner.where(user: current_user).find(params[:id])
    if @winner.update(params.require(:winner).permit(:address_id))
      @winner.claim!
      @winner.save
      redirect_to clients_profiles_path(history: 'winner')
      flash[:notice] = "#{@winner.item.name} Successfully Claimed"
    else
      render :show
    end
  end
end
