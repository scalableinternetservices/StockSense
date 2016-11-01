class StocksController < ApplicationController
	before_action :find_stock, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!, only: [:new, :edit]
	# before_action :retrieve_stockTwists_comments, only: [:show]
	before_action :retrieve_stock_info, only: [:show]

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
		require 'cgi'
		require 'net/http'
		require 'json'
		url = 'https://api.stocktwits.com/api/2/streams/symbol/' + @stock.symbol + '.json'
		uri = URI(url)
		response = Net::HTTP.get(uri)
		jsonInfo = JSON.parse(response)
		@tweets = Array.new
		for message in jsonInfo["messages"]
			@tweets.push(message["body"])
		end
		puts @tweets
	end

	def new
		@stock = current_user.stocks.build
		@industries = Industry.all.map{ |i| [i.name, i.id] }
	end

	def create
		yahoo_client = YahooFinance::Client.new
		data = yahoo_client.quotes([stock_params["symbol"]], [:name])
		name = data[0].name
		@stock = current_user.stocks.build(stock_params)
		@stock.name = name
		@stock.industry_id = params[:industry_id]
		if name != "N/A" && @stock.save
			redirect_to root_path
		else
			puts "invalid"
			redirect_to root_path
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
