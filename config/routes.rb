Rails.application.routes.draw do
  devise_for :users
  resources :yarns
  resources :patterns do
    post 'duplicate', on: :member
  end
  resources :users
  resources :drafts
  get "about" => "pages#about"
  root to: "patterns#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
