class AddStockIdToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :stock_id, :integer
  end
end
