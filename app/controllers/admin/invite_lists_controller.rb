class Admin::InviteListsController < AdminController
  require 'csv'

  def index
    @users = User.includes(:parent, :children, :bets).client.where.not(parent: nil)
    @users = @users.where(parent: { email: params[:parent_email] }) if params[:parent_email].present?
    respond_to do |format|
      format.html
      format.csv {
        csv_string = CSV.generate do |csv|
          csv << [User.human_attribute_name(:id),
                  User.human_attribute_name(:parent_email),
                  User.human_attribute_name(:email),
                  User.human_attribute_name(:total_deposit),
                  User.human_attribute_name(:member_total_deposit),
                  User.human_attribute_name(:coins),
                  User.human_attribute_name(:total_used_coins),
                  User.human_attribute_name(:children_members),
                  User.human_attribute_name(:created_at)]
          @users.each do |user|
            csv << [user.id,
                    user.parent&.email,
                    user.email,
                    user.total_deposit,
                    user.children.sum(&:total_deposit),
                    user.coins,
                    user.bets.where.not(state: :cancelled).count,
                    user.children_members,
                    user.created_at]
          end
        end
        render plain: csv_string
      }
    end
  end
end
