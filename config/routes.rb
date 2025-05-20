Rails.application.routes.draw do
  resources :tournaments, except: :show do
    member do
      get 'results'
      post 'team_scores_update'
    end
  end

  get '/user_role_request/:id/approve', to: 'user_role_requests#approve', as: 'approve_user_role_request'
  get '/user_role_request/:id/deny', to: 'user_role_requests#deny', as: 'deny_user_role_request'

  get '/profile', to: 'users#profile'

  get '/tournaments/administration/:id/:round', to: 'tournaments#administration', as: 'administration_tournament'
  get '/tournaments/display/:id/:court', to: 'tournaments#display', as: 'display'
  post '/tournaments/submit_scores', to: 'tournaments#submit_scores'
  post '/tournaments/update_scores', to: 'tournaments#update_scores'
  post '/tournaments/set_stale', to: 'tournaments#set_stale'
  post '/tournaments/admin_connection', to: 'tournaments#admin_connection'
  get '/tournaments/status/:id/:court_number/:timestamp', to: 'tournaments#status'

  get '/players', to: 'players#index', as: 'players'
  post '/create_player', to: 'players#create', as: 'create_player'
  get '/players/new', to: 'players#new', as: 'new_player'
  get '/players/:id/edit', to: 'players#edit', as: 'edit_player'

  get '/users', to: 'users#index'

  get '/leaderboard', to: 'players#leaderboard', as: 'leaderboard'

  get '/home', to: 'home#home', as: 'home'
  get '/learn_more', to: 'home#learn_more', as: 'learn_more'
  get '/subscription', to: 'home#subscription', as: 'subscription'
  get '/confirmation', to: 'home#confirmation', as: 'confirmationw'

  devise_for :users, controllers: { registrations: 'registrations', sessions: 'sessions' }

  resources :users
  resources :teams
  post '/user_deactivate', to: 'users#deactivate', as: 'user_deactivate'
  # post '/user_delete', to: 'users#destroy', as: 'user_delete'
  
  get '/sign_up', to: 'registrations#new'
  
  get 'dashboard', to: 'dashboard#index'
  
  root 'home#home'

  post '/webhooks/stripe', to: 'webhooks#stripe'

  resources :webhooks, only: [] do
    collection do
      post :stripe
    end
  end


  # Add this temporary route to handle redirects from existing checkout sessions
  get '/subscription/success', to: 'subscriptions#success'
  get '/subscription/cancel', to: 'subscriptions#cancel'  

  resources :subscriptions, only: [:new, :create] do
    collection do
      get :success
      get :cancel
    end
  end

  # Add this route to handle POST to singular /subscription
  post '/subscription', to: 'subscriptions#create'

end
