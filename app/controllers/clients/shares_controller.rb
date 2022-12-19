class Clients::SharesController < ApplicationController
  before_action :set_winner, only: [:show, :update]

  def show; end

  def update
    if @winner.update(params.require(:winner).permit(:comment, :image))
      @winner.share!
      @winner.save
      redirect_to clients_profiles_path(history: 'winner')
      flash[:notice] = "Successfully Shared!"
    else
      render :show
    end
  end

  private

  def set_winner
    @winner = Winner.where(user: current_user).find(params[:id])
  end
end
