class Admin::NewsTickersController < AdminController
  before_action :set_news_ticker, only: [:edit, :update, :destroy]

  def index
    @news_tickers = NewsTicker.includes(:admin)
  end

  def new
    @news_ticker = NewsTicker.new
  end

  def create
    @news_ticker = NewsTicker.new(news_ticker_params)
    @news_ticker.admin = current_admin_user
    if @news_ticker.save
      flash[:notice] = "Successfully saved"
      redirect_to admin_news_tickers_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @news_ticker.update(news_ticker_params)
      redirect_to admin_news_tickers_path
      flash[:notice] = "Successfully edit"
    else
      render :edit
    end
  end

  def destroy
    @news_ticker.destroy
    redirect_to admin_news_tickers_path
    flash[:notice] = "Successfully deleted"
  end

  private

  def news_ticker_params
    params.require(:news_ticker).permit(:content, :status)
  end

  def set_news_ticker
    @news_ticker = NewsTicker.find(params[:id])
  end
end
