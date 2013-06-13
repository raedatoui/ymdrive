GoogleDrive::Application.routes.draw do

  root :to => 'home#index'
  match "/oauth" => 'home#oauth'
  match "/check" => 'home#check'
  match "/user" => 'files#user'

  resources :files
  resources :formats


end
