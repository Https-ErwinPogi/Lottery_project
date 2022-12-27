class Admin::MemberLevelListsController < AdminController
  before_action :set_member_level, only: [:edit, :update, :destroy]

  def index
    @members = MemberLevel.all
  end

  def new
    @member = MemberLevel.new
  end

  def create
    @member = MemberLevel.new(member_params)
    if @member.save
      redirect_to admin_member_level_lists_path
      flash[:notice] = "Successfully saved"
    else
      flash[:alert] = @member.errors.full_messages.join(', ')
    end
  end

  def edit; end

  def update
    if @member.update(member_params)
      redirect_to admin_member_level_lists_path
      flash[:notice] = "Successfully updated"
    else
      flash[:alert] = @member.errors.full_messages.join(', ')
    end
  end

  def destroy
    @member.destroy
    redirect_to admin_member_level_lists_path
    flash[:notice] = "Successfully delete"
  end

  private

  def set_member_level
    @member = MemberLevel.find(params[:id])
  end

  def member_params
    params.require(:member_level).permit(:required_members, :level, :coins)
  end
end
