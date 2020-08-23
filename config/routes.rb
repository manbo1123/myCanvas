Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  root "posts#index"
  resources :users, only: [:show, :edit, :update] do
    collection do
      get :favorites
    end
  end

  resources :posts, expect: [:index] do
    resource :favorites, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
  end
end
