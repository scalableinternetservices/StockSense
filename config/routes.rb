Rails.application.routes.draw do
  devise_for :users
  resources :stocks do
  	resources :reviews
  end
  root 'stocks#index'
end
