Rails.application.routes.draw do
  use_doorkeeper do
    # it accepts :authorizations, :tokens, :applications and :authorized_applications
    controllers authorizations: "doorkeeper/authorizations_with_role_check"
  end
  devise_for :users, skip: [:registrations], controllers: { sessions: "sessions" }

  resources :users, except: [:new, :create]

  resources :organisations do
    resources :users
    resources :memberships
  end

  root "welcome#index"

  namespace :api, format: "json" do
    namespace :v1 do
      get "me" => "users#me"
      resources :organisations, only: [:index, :show], param: :uid
      resources :users, only: [:index, :show], param: :uid do
        get "me", on: :collection
      end

      # support legacy /api/v1/profiles/me route
      get "profiles/me" => "users#me"
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
