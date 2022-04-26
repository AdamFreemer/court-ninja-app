Rails.application.routes.draw do
  resources :tournaments, except: :show do
    member do
      get 'round_one'
      get 'round_two'
      get 'results'
      post 'team_scores_update'
    end
  end
  get '/tournament/process_round/:id/:round', to: 'tournaments#process_round'
  get '/tournaments/round_display/:id/:round', to: 'tournaments#round_display'
  get '/tournaments/round_display_single/:id/:round/:court', to: 'tournaments#round_display_single'

  resources :users
  devise_for :users

  root 'tournaments#index'
end
