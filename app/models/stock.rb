class Stock < ActiveRecord::Base
	belongs_to :user
	belongs_to :industry
	has_many :reviews

	has_attached_file :stock_img, styles: { stock_index: "300x300>", stock_show: "100x100>" }, default_url: "/images/:style/missing.png"
	validates_attachment_content_type :stock_img, content_type: /\Aimage\/.*\z/
end
