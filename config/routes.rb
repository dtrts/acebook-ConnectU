Rails.application.routes.draw do
  resources :room_messages
  resources :rooms
  # resources :users, controller: 'users', only: [:create]

  resources :passwords, controller: 'clearance/passwords', only: %i[create new]
  resource :session, controller: 'clearance/sessions', only: [:create]

  resources :users, controller: 'users', only: [:create] do
    resource :password,
             controller: 'clearance/passwords',
             only: %i[create edit update]
  end

  get '/sign_in' => 'clearance/sessions#new', as: 'sign_in'
  delete '/sign_out' => 'clearance/sessions#destroy', as: 'sign_out'
  get '/sign_up' => 'clearance/users#new', as: 'sign_up'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :posts do
    resources :comments, shallow: true
  end
  # root 'posts#index'
  resources :profile, only: [:index]

  # get '/users/:user_id' => 'users#show'

  resources :users, only: [:show] do
    post :posts, to: 'posts#wall_create'
    # resources :posts, controller: 'wall_post', as: 'wall_post', only: [:create]
  end

  root 'application#index'
end
