class StocksController < ApplicationController

	before_action :find_stock, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!, only: [:new, :edit]
	# before_action :retrieve_stockTwists_comments, only: [:show]
	before_action :retrieve_stock_info, only: [:show]
  before_action :retrieve_google_trend, only: [:show]

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
			@error_info = "Invalid Symbol! Please look up a correct symbol on http://www.nasdaq.com/screening/company-list.aspx"
			redirect_to new_stock_path
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


		def retrieve_stockTwists_comments
			require 'cgi'
			require 'net/http'
			require 'json'
			require 'uri'
			url = request.original_url
			params = URI.parse(url)
			url = 'https://api.stocktwits.com/api/2/streams/symbol/fb.json'
			uri = URI(url)
			response = Net::HTTP.get(uri)
			@jsonInfo = JSON.parse(response)
			tweets = @jsonInfo["messages"]
		end
		def retrieve_stock_info
			yahoo_client = YahooFinance::Client.new
			@data = yahoo_client.quotes([@stock.symbol], [:ask, :bid, :low, :high, :low_52_weeks, :high_52_weeks, :last_trade_date,:last_trade_price, :notes, :open, :close, :market_capitalization,  :market_capitalization, :volume, :one_year_target_price, :average_daily_volume], { raw: false } )
			# @stockInfo = "#{@stock.symbol} value is:  #{data[0].ask}"
		end

		def retrieve_google_trend
			require 'cgi'
			require 'net/http'
			require 'json'
			require 'uri'
			# https://www.google.com/fetchComponent?hl=en-US&q=Apple&geo=US&cid=RISING_QUERIES_0_0
			# https://www.google.com/trends/fetchComponent?hl=en-US&q=jquery&geo=US&cid=RISING_QUERIES_0_0
			uri=URI.join("https://www.google.com","/trends/fetchComponent?hl=en-US&q=#{@stock.name}&geo=US&cid=RISING_QUERIES_0_0")
			response = Net::HTTP.get(uri)
			@jsonInfo = response
			# render @jsonInfo
	    # @page_content = open(@url)
	    # return parseContent(page_content)
			# require 'pp'
			#
			# gm = GTrendManager.new()
			# # search word is AMAZON, searched results are created from 2012/10 to 2012/11
			# gresult_1 = gm.request(GRequest.new("AMAZON", 2012, 10))
			# # display search result
			# gm.printResult(gresult_1)
			#
			# # output search result as csv file
			# gm.outputAsCsv(gresult_1, "result_amazon.csv")
			#
			# # search words are AMAZON and Kindle, searched results are created from 2012/10 to 2013/1
			# gresult_2 = gm.request(GRequest.new("AMAZON+Kindle", 2012, 10, 3))
			#
			# # output search result as csv file
			# gm.outputAsCsv(gresult_2, "result_amazon_and_kindle.csv")
			#
			# # convert search result to array(hash) and print it : Result is [ {"date"=>"2012-10-1", "number"=>"53"}, ... ]
			# pp gm.getResultAsArray(gresult_2)
			# require 'cgi'
			# require 'net/http'
			# require 'json'
			# require 'uri'
			# # https://www.google.com/fetchComponent?hl=en-US&q=Apple&geo=US&cid=RISING_QUERIES_0_0
			# # https://www.google.com/trends/fetchComponent?hl=en-US&q=jquery&geo=US&cid=RISING_QUERIES_0_0
			# uri=URI.join("https://www.google.com","/trends/fetchComponent?hl=en-US&q=#{@stock.name}&geo=US&cid=RISING_QUERIES_0_0")
			# response = Net::HTTP.get(uri)
			# @jsonInfo = response
			# render @jsonInfo
			# tweets = @jsonInfo["messages"]
		end
end
