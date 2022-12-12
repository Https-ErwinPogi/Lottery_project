class CreateBets < ActiveRecord::Migration[7.0]
  def change
    create_table :bets do |t|
      t.references :item
      t.references :user
      t.integer :coins, default: 1
      t.string :state
      t.string :serial_number
      t.integer :batch_count, default: 0
      t.timestamps
    end
  end
end
