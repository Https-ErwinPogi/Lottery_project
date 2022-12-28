class AddSortColumn < ActiveRecord::Migration[7.0]
  def change
    add_column :banners, :sort, :integer
    add_column :news_tickers, :sort, :integer
    add_column :categories, :sort, :integer
  end
end
