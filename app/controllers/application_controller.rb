class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  before_action :setup_industry_names


  private
  def setup_industry_names
    @industry_names = ["Consumer Discretionary", "Consumer Staples", "Energy", "Financials", "Health Care", "Industrials", "Information Technology", 
    	            "Materials", "Real Estate", "Telecommunication Services", "Utilities"]
  end
end
