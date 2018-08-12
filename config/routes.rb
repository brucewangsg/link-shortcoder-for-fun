Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :links do
    collection do
      get :check
    end
    member do 
      get :stats
    end
  end

  get '/stats/:id', controller: :links, action: :stats
  get '/:id', controller: :links, action: :show
  root :to => 'homepage#index'
end
