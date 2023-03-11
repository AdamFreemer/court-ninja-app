Rails.application.routes.draw do
  resources :tournaments, except: :show do
    member do
      get 'results'
      post 'team_scores_update'
    end
  end

  authenticated :user do
    root 'dashboard#index', as: :root #-> if user is logged in
    # resources :controller #-> ONLY available for logged in users
  end

  unauthenticated :user do
    root 'dashboard#landing', as: :unauthenticated #-> if user is not logged in
  end

  get '/me', to: 'users#show'

  get '/user_role_request/:id/approve', to: 'user_role_requests#approve', as: 'approve_user_role_request'
  get '/user_role_request/:id/deny', to: 'user_role_requests#deny', as: 'deny_user_role_request'

  get '/approve_team/:uuid', to: 'teams#existing_athlete_join_team_approval', as: 'existing_athlete_join_team_approval'

  get '/tournaments/administration/:id/:round', to: 'tournaments#administration', as: 'administration_tournament'
  get '/tournaments/display/:id/:court', to: 'tournaments#display', as: 'display'

  post '/tournaments/submit_scores', to: 'tournaments#submit_scores'
  post '/tournaments/update_scores', to: 'tournaments#update_scores'
  post '/tournaments/set_stale', to: 'tournaments#set_stale'

  post '/tournaments/admin_connection', to: 'tournaments#admin_connection'
  get '/tournaments/status/:id/:court_number/:timestamp', to: 'tournaments#status'

  devise_for :users#, controllers: { registrations: 'registrations' }

  resources :users, only: [:show, :edit, :update]
  resources :teams, except: :index do
    collection do
      get 'verify'
      post 'join'
      delete 'remove_player'
    end

    member do
      post 'add_player_to_team'
    end
  end

  # root 'dashboard#index'
end
