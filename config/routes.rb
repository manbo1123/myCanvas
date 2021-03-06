Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }

  root "posts#index"
  resources :users, only: [:show, :edit, :update] do
    get :favorites, on: :collection
  end

  resources :posts, expect: [:index] do
    resource :favorites, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
    get 'get_tag_search', on: :collection, defaults: { format: 'json' }
    get 'get_tag_search', on: :member, defaults: { format: 'json' }
  end

  #get 'tags/:tag', to: "posts#index", as: :tag
end
