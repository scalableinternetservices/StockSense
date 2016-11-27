######################################
# config
######################################

# allow_image_upload = true && total_num_of_users = 20         -- 3 min
# allow_image_upload = true && total_num_of_users = 50         -- 7 min
# allow_image_upload = false && total_num_of_users = 50        -- 1 min
# allow_image_upload = false && total_num_of_users = 500       -- 5 min
require 'faker'

allow_randomness = false
allow_image_upload = false

total_num_of_users = 10
total_num_of_stocks = 0        # total_num_of_stocks is calculated later
total_num_of_reviews = 0   # total_num_of_reviews is calculated later

avg_num_of_stocks_per_user = 2
avg_num_of_reviews_per_user = 10



sample_stock_img_file = File.new("#{Rails.root}/load_tests/sample_stock_img.jpg")

######################################
# create Industries
######################################

Industry.create(name: 'Consumer Discretionary')
Industry.create(name: 'Consumer Staples')
Industry.create(name: 'Energy')
Industry.create(name: 'Financials')
Industry.create(name: 'Health Care')
Industry.create(name: 'Industrials')
Industry.create(name: 'Information Technology')
Industry.create(name: 'Materials')
Industry.create(name: 'Real Estate')
Industry.create(name: 'Telecommunication Services')
Industry.create(name: 'Utilities')

######################################
# create users
######################################

total_num_of_users.times do |n_user|
  puts 'Creating user: user_' + (n_user + 1).to_s
  user = User.create(
    email: "user_" + (n_user + 1).to_s + "@gmail.com",
    password: "88888888",
    password_confirmation: "88888888",
  )
end

######################################
# user create stocks
######################################



symbols = Array['AAPL', 'GOOGL', 'GOOG', 'MSFT', 'AMZN', 'FB', 'INTC', 'CMCSA', 'CSCO', 'AMGN', 'KHC', 'QCOM', 'GILD', 'CELG', 'WBA', 'SBUX', 'PCLN', 'CHTR', 'TXN', 'AVGO', 'MDLZ', 'BIIB', 'COST', 'FOX', 'ADBE', 'NVDA', 'NFLX', 'PYPL', 'ESRX', 'BIDU', 'TMUS', 'ADP', 'REGN', 'QQQ', 'YHOO', 'CME', 'FOXA', 'AMAT', 'NXPI', 'CSX', 'EBAY', 'CTSH', 'TSLA', 'MAR', 'INTU', 'LBTYA', 'LBTYB', 'LBTYK', 'ATVI', 'ROST', 'ALXN', 'ORLY', 'DISH', 'MNST', 'ISRG', 'AAL', 'EQIX', 'EA', 'JD', 'FISV', 'ADI', 'SIRI', 'VRTX', 'PCAR', 'AMTD', 'DLTR', 'PAYX', 'MU', 'HBANO', 'INCY', 'ILMN', 'FITB', 'MYL', 'EXPE', 'CTRP', 'NTRS', 'TROW', 'WDC', 'LRCX', 'NTES', 'CERN', 'WLTW', 'ADSK', 'VIA', 'ULTA', 'SHPG', 'VCSH', 'SYMC', 'IBKR', 'BMRN', 'LLTC', 'INFO', 'CHKP', 'SWKS', 'MCHP', 'VRSK', 'XRAY', 'CTXS', 'HBAN', 'XLNX']
num_industries = 11

i = 0
while i < 100 do
    stock = Stock.create(
        name: symbols[i],
        description: (0...8).map { (65 + rand(26)).chr }.join,
        symbol: symbols[i],
        user_id: 0,
        industry_id: i % 11,
    )
    total_num_of_stocks += 1
    i += 1
end

stock_ids_array = (1..total_num_of_stocks).to_a
######################################
# user create reviews
######################################
total_num_of_users.times do |n_user|
  user_id = n_user + 1
  puts 'User ' + user_id.to_s + ' creates reviews'
  num_of_reviews = allow_randomness ? rand(avg_num_of_reviews_per_user * 2 + 1) : avg_num_of_reviews_per_user
  stock_ids_array.sample(num_of_reviews).each do |stock_id|
    puts '- adding review to stock:' + stock_id.to_s
    review = Review.create(
      stock_id: stock_id,
      user_id: user_id,
      comment: Faker::Lorem.sentence,
      rating: rand(1..5)
    )
    total_num_of_reviews += 1
  end
end


puts '===='
puts 'Total number of stocks: ' + total_num_of_stocks.to_s
puts 'Total number of reviews: ' + total_num_of_reviews.to_s