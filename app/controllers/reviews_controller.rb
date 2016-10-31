class ReviewsController < ApplicationController
	before_action :find_stock
	before_action :find_review, only: [:edit, :update, :destroy]
	before_action :authenticate_user!, only: [:new, :edit]
	
	def new
		@review = Review.new
	end

	def create
		@review = Review.new(review_params)
		@review.stock_id = @stock.id
		@review.user_id = current_user.id
		if @review.save
			redirect_to stock_path(@stock)
		else
			render 'new'
		end
	end

	def edit
	end

	def update
		if @review.update(review_params)
			redirect_to stock_path(@stock)
		else
			render 'edit'
		end
	end

	def destroy
		@review.destroy	
		redirect_to stock_path(@stock)
	end

	private
		def review_params
			params.require(:review).permit(:rating, :comment)
		end

		def find_stock
			@stock = Stock.find(params[:stock_id])
		end

		def find_review
			@review = Review.find(params[:id])
		end
end
