Rails.application.routes.draw do

  root 'welcome#index'

  resources :styles
  resources :beer_clubs
  resources :ratings, only: [:index, :new, :create, :destroy]
  resources :memberships
  resources :memberships do
    post 'toggle_confirmed', on: :member
  end


  resources :users
  get 'signup', to: 'users#new'
  resources :users do
    post 'toggle_iced', on: :member
  end


  resources :breweries
  resources :breweries do
    post 'toggle_activity', on: :member
  end
  get 'brewerylist', to:'breweries#list'


  resources :beers
  get 'beerlist', to:'beers#list'
  get 'ngbeerlist', to:'beers#nglist'


  resource :session, only: [:new, :create, :destroy]
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'
  get 'auth/:provider/callback', to: 'sessions#create_oauth'

  resources :places, only:[:index, :show]
  get 'places', to: 'places#index'
  post 'places', to:'places#search'
end
