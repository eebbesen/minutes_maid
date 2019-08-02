# frozen_string_literal: true

# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  get 'static_pages/about'
  resources :notes
  resources :items
  resources :meetings

  devise_for :users, controllers: { registrations: 'registrations' }
  devise_scope :user do
    get '/users', to: 'registrations#new'
  end

  root to: 'meetings#index'
end
