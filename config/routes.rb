Rails.application.routes.draw do
  resources :tournaments, except: :show do
    member do
      get 'results'
      post 'team_scores_update'
    end
  end

  get '/profile', to: 'users#profile'

  get '/tournaments/administration/:id/:round', to: 'tournaments#administration', as: 'administration_tournament'
  get '/tournaments/display/:id/:court', to: 'tournaments#display', as: 'display'
  post '/tournaments/submit_scores', to: 'tournaments#submit_scores'
  post '/tournaments/update_scores', to: 'tournaments#update_scores'
  post '/tournaments/set_stale', to: 'tournaments#set_stale'
  post '/tournaments/admin_connection', to: 'tournaments#admin_connection'
  get '/tournaments/status/:id/:court_number/:timestamp', to: 'tournaments#status'

  get '/players', to: 'players#index', as: 'players'
  get '/players/new', to: 'players#new', as: 'new_player'
  post '/create_player', to: 'players#create', as: 'create_player'

  get '/admin', to: 'users#index', as: 'users'

  devise_for :users, controllers: { registrations: 'registrations' }

  resources :users
  post '/user_delete', to: 'users#destroy', as: 'user_delete'
  root 'tournaments#index'
end
