class AddDefaultToMemberLevelsCoins < ActiveRecord::Migration[7.0]
  def change
    change_column :member_levels, :coins, :integer, default: 0
  end
end
