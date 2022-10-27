Rails.application.routes.draw do
  
  resources :palestras do
    collection do
      get :all
      get :file
      post :upload, as: :palestras_upload
    end
  end

  
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :palestras, only: [:create]
    end
  end

end
