Rails.application.routes.draw do
  resources :tournaments
  resources :users
  devise_for :users
  post '/team_scores_update', to: 'tournaments#team_scores_update'
  get '/tournament_round_two/:id', to: 'tournaments#show_round_two'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # root to: "home#index"
end
