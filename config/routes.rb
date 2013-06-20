GoogleDrive::Application.routes.draw do

  root :to => 'home#index'
  match "/oauth" => 'home#oauth'
  match "/check" => 'home#check'
  match "/user" => 'files#user'
  match "/sync" => 'files#sync'
  match "/connect" => "samba#connect"
  match "/connected" => "samba#connected"
  match "/samba_check" => "samba#check"

  resources :files
  resources :formats
  resources :samba

end
