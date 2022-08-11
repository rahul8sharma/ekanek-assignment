Rails.application.routes.draw do
  resources :documents do
    collection do
      post 'chunk_create' => 'documents#chunk_create'
      get 'compress'
    end
  end
  devise_for :users
  root to: "documents#index"
end
