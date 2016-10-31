class AddIndustryIdToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :industry_id, :integer
  end
end
