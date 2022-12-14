class CreateOffers < ActiveRecord::Migration[7.0]
  def change
    create_table :offers do |t|
      t.string :image
      t.string :name
      t.integer :genre
      t.integer :status
      t.float :amount, precision: 12, scale: 2
      t.integer :coin
      t.timestamps
    end
  end
end
