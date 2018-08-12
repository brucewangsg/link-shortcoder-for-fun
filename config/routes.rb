Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :links do
    collection do
      get :check
    end
  end

  resources :stats, only: [:index, :show]

  get '/:id', controller: :links, action: :show
  root :to => 'homepage#index'
end
