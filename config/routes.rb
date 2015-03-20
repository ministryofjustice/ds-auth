Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, skip: [:registrations]

  as :user do
    get 'users/edit' => 'devise/registrations#edit', as: 'edit_user_registration'
    patch 'users/:id' => 'devise/registrations#update', as: 'user_registration'
  end

  root 'welcome#index'

  get '/status' => 'status#index'
  get '/help', controller: :static, action: :help, as: :help
  get '/maintenance', controller: :static, action: :maintenance, as: :maintenance
  get '/cookies', controller: :static, action: :cookies, as: :cookies
  get '/accessibility', controller: :static, action: :accessibility, as: :accessibility
  get '/terms', controller: :static, action: :terms, as: :terms
  get '/expired', controller: :static, action: :expired, as: :expired
end
