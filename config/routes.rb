# coding: utf-8

JapanTravelApi::Application.routes.draw do
  resources :areas, only: [:index]

  resources :bookmarks do
    collection do
      get '/spots', to: 'bookmarks#get_bookmarked_spot'
      get '/posts', to: 'bookmarks#get_bookmarked_posts'
    end
  end

  resources :comments
  post "/comments/create", to: "comments#create_comment"
  post "/comments/reply", to: "comments#create_reply"

  resources :events, only: [:show]

  resources :places, only: [:index, :show] do
    get :search, format: :json, on: :collection
  end
  get "/places/:id/comments", to: "places#get_comment"
  get "/places/:id/posts",  to: "places#get_post"

  resources :posts do
    collection do
      post "/create", to: "posts#create_normal_post"
      get  "/share/:id", to:  "posts#fb_share"
    end
  end

  resources :albums, only: [:index]
  get '/albums/:place_id/:year', to: "albums#show"

  get "/timeline", to: "posts#timeline"
  post "/spots/checkins/create", to: "posts#create_checkin"

  resources :spots, only: [:index, :show] do
    get :search, format: :json, on: :collection
  end
  get "spots/:id/posts", to: "spots#show_images"

  resources :users do
    collection do
      post 'login/facebook', to: 'users#login_with_facebook'
      post 'logout', to: 'users#logout'
      post 'delete', to: 'users#delete'
    end
  end

  resources :fb_shares, only: [:create]

  mount RailsAdmin::Engine => '/rails_admin', :as => 'rails_admin'
  devise_for :admins
end
