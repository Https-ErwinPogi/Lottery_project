class Admin::CategoriesController < AdminController
  before_action :set_category, only: [:edit, :update, :destroy]

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(params_category)
    if @category.save
      redirect_to admin_categories_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @category.update(params_category)
      redirect_to admin_categories_path
    else
      render :edit
    end
  end

  def destroy
    @category.destroy
    if @category.deleted_at
      flash[:notice] = "Successfully Deleted"
    else
      flash[:alert] = "This category can't be deleted, it has record on item!"
    end
    redirect_to admin_categories_path
  end

  private

  def params_category
    params.require(:category).permit(:name)
  end

  def set_category
    @category = Category.find(params[:id])
  end
end
