class Admin::ItemsController < AdminController
  before_action :set_item, only: [ :edit, :update, :destroy ]

  def index
    @items = Item.includes(:categories)
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      flash[:notice] = 'The items was successfully saved'
      redirect_to admin_items_path
    else
      render :new
    end
  end

  def edit ;end

  def update
    if @item.update(item_params)
      flash[:notice] = 'The items was successfully saved'
      redirect_to admin_items_path
    else
      render :edit
    end
  end

  def destroy
    if @item.destroy
      redirect_to admin_items_path
    end
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :image, :quantity, :minimum_bets, :state, :batch_count, :online_at, :offline_at, :start_at, :status, category_ids: [])
  end
end
