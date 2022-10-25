Rails.application.routes.draw do
  
  resources :palestras do
    collection do
      get :organize
      get :sendfile
      post :add, as: :palestras_add
    end
  end

  
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :palestras, only: [:create]
    end
  end

end
