Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  use_doorkeeper
  devise_for :users, skip: [:registrations]

  resources :users, except: [:show]
  resources :profiles, except: [:show]
  resources :roles, except: [:edit, :update, :show]
  resources :organisations

  root 'welcome#index'

  get '/status' => 'status#index'
  get '/help', controller: :static, action: :help, as: :help
  get '/maintenance', controller: :static, action: :maintenance, as: :maintenance
  get '/cookies', controller: :static, action: :cookies, as: :cookies
  get '/accessibility', controller: :static, action: :accessibility, as: :accessibility
  get '/terms', controller: :static, action: :terms, as: :terms
  get '/expired', controller: :static, action: :expired, as: :expired
end
