Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  root "posts#index"
  resources :users, only: [:show, :edit, :update]
  resources :posts, expect: [:index]
end
