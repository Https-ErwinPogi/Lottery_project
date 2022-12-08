class Admin::ItemsController < AdminController
  before_action :set_item, only: [:edit, :update, :destroy]
  before_action :set_item_event, only: [:start, :pause, :end, :cancel]

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

  def edit; end

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

  def start
    if @item.may_start?
      @item.start!
    else
      flash[:notice] = 'You cant start the item, there might have unmeet conditions in the items'
    end
  end

  def pause
    if @item.may_pause?
      @item.pause!
    else
      flash[:notice] = 'Item cant be pause'
    end
  end

  def end
    if @item.may_end?
      @item.end!
    else
      flash[:notice] = 'Item cant be end'
    end
  end

  def cancel
    if @item.may_cancel?
      @item.cancel!
    else
      flash[:notice] = 'Item cant be cancel'
    end
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def set_item_event
    @item = Item.find(params[:item_id])
  end

  def item_params
    params.require(:item).permit(:name, :image, :quantity, :minimum_bets, :state, :batch_count, :online_at, :offline_at, :start_at, :status, category_ids: [])
  end
end
