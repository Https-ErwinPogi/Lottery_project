class Admin::BannersController < AdminController
  before_action :set_banner, only: [:edit, :update, :destroy]

  def index
    @banners = Banner.all
  end

  def new
    @banner = Banner.new
  end

  def create
    @banner = Banner.new(banner_params)
    if @banner.save
      redirect_to admin_banners_path
      flash[:notice] = "Successfully Saved"
    else
      render :new
    end
  end

  def edit; end

  def update
    if @banner.update(banner_params)
      redirect_to admin_banners_path
      flash[:notice] = "Successfully edit"
    else
      render :edit
    end
  end

  def destroy
    @banner.destroy
    flash[:notice] = "Successfully deleted"
    redirect_to admin_banners_path
  end

  private

  def banner_params
    params.require(:banner).permit(:preview, :status, :online_at, :offline_at)
  end

  def set_banner
    @banner = Banner.find(params[:id])
  end
end
