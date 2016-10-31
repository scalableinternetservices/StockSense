class StocksController < ApplicationController
	before_action :find_stock, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!, only: [:new, :edit]

	def index
		if params[:industry].blank?
			@stocks = Stock.all.order("created_at DESC")
		else
			@industry_id = Industry.find_by(name: params[:industry]).id
			@stocks = Stock.where(:industry_id => @industry_id).order("created_at DESC")
		end
		
	end

	def show
		if @stock.reviews.blank?
			@average_review = 0
		else
			@average_review = @stock.reviews.average(:rating).round(2)
		end
	end

	def new
		@stock = current_user.stocks.build
		@industries = Industry.all.map{ |i| [i.name, i.id] }
	end

	def create
		@stock = current_user.stocks.build(stock_params)
		@stock.industry_id = params[:industry_id]

		if @stock.save
			redirect_to root_path
		else
			render 'new'
		end
	end

	def edit
		@industries = Industry.all.map{ |i| [i.name, i.id] }
	end

	def update
		@stock.industry_id = params[:industry_id]
		if @stock.update(stock_params)
			redirect_to stock_path(@stock)
		else
			render 'edit'
		end
	end

	def destroy
		@stock.destroy
		redirect_to root_path
	end

	private
		def stock_params
			params.require(:stock).permit(:name, :description, :symbol, :industry_id, :stock_img)
		end

		def find_stock
			@stock = Stock.find(params[:id])
		end
end
