Rails.application.routes.draw do
  root 'dashboard#index'

  devise_for :users, :controllers => { :registrations => "users/registrations" }

  devise_scope :user do
    # sessions
    post '/users/update_retirement_year', to: 'users/registrations#update_retirement_year'
  end

  resources :dashboard
  resources :accounts

  # Added
  post '/accounts/create', to: 'accounts#create'
  post '/accounts/update', to: 'accounts#update'

end
