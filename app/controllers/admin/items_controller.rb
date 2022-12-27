class Admin::ItemsController < AdminController
  before_action :set_item, only: [:edit, :update, :destroy]
  before_action :set_item_event, only: [:start, :pause, :end, :cancel]
  require 'csv'

  def index
    @items = Item.includes(:categories)
    respond_to do |format|
      format.html
      format.csv {
        csv_string = CSV.generate do |csv|
          csv << [Item.human_attribute_name(:id),
                  Item.human_attribute_name(:name),
                  Item.human_attribute_name(:quantity),
                  Item.human_attribute_name(:minimum_bets),
                  Item.human_attribute_name(:batch_count),
                  Item.human_attribute_name(:state),
                  Item.human_attribute_name(:category),
                  Item.human_attribute_name(:online_at),
                  Item.human_attribute_name(:offline_at),
                  Item.human_attribute_name(:start_at),
                  Item.human_attribute_name(:status),
                  Item.human_attribute_name(:created_at)]
          @items.each do |item|
            csv << [item.id,
                    item.name,
                    item.quantity,
                    item.minimum_bets,
                    item.batch_count,
                    item.state,
                    item.categories.pluck(:name).join(','),
                    item.online_at,
                    item.offline_at,
                    item.start_at,
                    item.status,
                    item.created_at]
          end
        end
        render plain: csv_string
      }
    end
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
      flash[:notice] = 'The items was successfully delete'
    else
      redirect_to admin_items_path
      flash[:alert] = "You can't delete item that has bet"
    end
  end

  def start
    if @item.may_start?
      @item.start!
      redirect_to admin_items_path
    else
      flash[:alert] = 'You cant start the item, there might have unmeet conditions in the items'
      redirect_to admin_items_path
    end
  end

  def pause
    if @item.may_pause?
      @item.pause!
      redirect_to admin_items_path
    else
      flash[:alert] = 'Item cant be pause'
      redirect_to admin_items_path
    end
  end

  def end
    if @item.may_end?
      @item.end!
      redirect_to admin_items_path
    else
      flash[:alert] = 'Item cant be end'
      redirect_to admin_items_path
    end
  end

  def cancel
    if @item.may_cancel?
      @item.cancel!
      redirect_to admin_items_path
    else
      flash[:alert] = 'Item cant be cancel'
      redirect_to admin_items_path
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
