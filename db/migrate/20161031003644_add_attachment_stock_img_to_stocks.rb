class AddAttachmentStockImgToStocks < ActiveRecord::Migration
  def self.up
    change_table :stocks do |t|
      t.attachment :stock_img
    end
  end

  def self.down
    remove_attachment :stocks, :stock_img
  end
end
