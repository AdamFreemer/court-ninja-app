Rails.application.routes.draw do
  resources :tournaments, except: :show do
    member do
      get 'results'
      get 'status'
      post 'team_scores_update'
    end
  end

  get '/tournaments/administration/:id/:round', to: 'tournaments#administration', as: 'administration_tournament'
  get '/tournaments/display_single/:id/:round/:court', to: 'tournaments#display_single'
  get '/tournaments/display_double/:id/:round', to: 'tournaments#display_double'


  get '/tournament/process_round/:id/:round', to: 'tournaments#process_round'
  post '/tournaments/timer_operation', to: 'tournaments#timer_operation'

  devise_for :users

  root 'tournaments#index'
end
