Rails.application.routes.draw do
  resources :tournaments, except: :show do
    member do
      get 'results'
      get 'status'
      post 'team_scores_update'
    end
  end

  get '/user_role_request/:id/approve', to: 'user_role_requests#approve', as: 'approve_user_role_request'
  get '/user_role_request/:id/deny', to: 'user_role_requests#deny', as: 'deny_user_role_request'

  get '/tournaments/administration/:id/:round', to: 'tournaments#administration', as: 'administration_tournament'
  get '/tournaments/display_single/:id/:round/:court', to: 'tournaments#display_single'
  get '/tournaments/display_double/:id/:round', to: 'tournaments#display_double'

  get '/tournament/process_round/:id/:round', to: 'tournaments#process_round'
  post '/tournaments/timer_operation', to: 'tournaments#timer_operation'

  devise_for :users, controllers: { registrations: 'registrations' }

  resources :users, only: [:show, :edit, :update]
  resources :teams, except: :index do
    collection do
      get 'verify'
      post 'join'
    end
  end

  root 'dashboard#index'
end
