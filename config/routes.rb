Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, skip: [:registrations]

  resources :users, except: [:show]
  resources :profiles, except: [:show]

  resources :organisations do
    resources :memberships, except: [:index, :edit, :update, :show]
  end

  resources :permissions, only: [:new, :index, :create, :destroy]

  root 'welcome#index'

  namespace :api, format: 'json' do
    namespace :v1 do
      get "/me", to: "credentials#show"
      resources :profiles, only: [:index, :show], param: :uid
      resources :organisations, only: [:index, :show], param: :uid
    end
  end

  get '/status' => 'status#index'
  get '/help', controller: :static, action: :help, as: :help
  get '/maintenance', controller: :static, action: :maintenance, as: :maintenance
  get '/cookies', controller: :static, action: :cookies, as: :cookies
  get '/accessibility', controller: :static, action: :accessibility, as: :accessibility
  get '/terms', controller: :static, action: :terms, as: :terms
  get '/expired', controller: :static, action: :expired, as: :expired
end
