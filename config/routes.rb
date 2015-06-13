Rails.application.routes.draw do
  use_doorkeeper do
    # it accepts :authorizations, :tokens, :applications and :authorized_applications
    controllers authorizations: "doorkeeper/authorizations_with_role_check"
  end
  devise_for :users, skip: [:registrations], controllers: { sessions: "sessions" }

  resources :users
  resources :profiles

  resources :organisations do
    resources :memberships, except: [:index, :edit, :update, :show]
  end

  resources :permissions, only: [:new, :index, :create, :destroy]

  root "welcome#index"

  namespace :api, format: "json" do
    namespace :v1 do
      resources :organisations, only: [:index, :show], param: :uid
      resources :profiles, only: [:index, :show], param: :uid do
        get "me", on: :collection
      end
    end
  end

  get "/status" => "status#index"
  get "/ping" => "status#ping"

  get "/help", controller: :static, action: :help, as: :help
  get "/maintenance", controller: :static, action: :maintenance, as: :maintenance
  get "/cookies", controller: :static, action: :cookies, as: :cookies
  get "/accessibility", controller: :static, action: :accessibility, as: :accessibility
  get "/terms", controller: :static, action: :terms, as: :terms
  get "/expired", controller: :static, action: :expired, as: :expired
end
