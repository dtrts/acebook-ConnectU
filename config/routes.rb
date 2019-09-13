Rails.application.routes.draw do
  # resources :users, controller: 'users', only: [:create]

  resources :passwords, controller: 'clearance/passwords', only: %i[create new]
  resource :session, controller: 'sessions', only: [:create]
  resources :users, controller: 'users', only: [:create] do
    resource :password, controller: 'clearance/passwords', only: %i[create edit update]
    resources :posts, shallow: true # only: [:index]
    # resources :posts, only: [:index], controller: 'user_posts' # example of a custom controller.
  end

  get '/sign_in' => 'clearance/sessions#new', as: 'sign_in'
  delete '/sign_out' => 'clearance/sessions#destroy', as: 'sign_out'
  get '/sign_up' => 'clearance/users#new', as: 'sign_up'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # resources :posts do
  #   get 'all'
  # end
  get '/posts', to: 'posts#all'
  # root 'posts#index'

  root 'application#index'
end
