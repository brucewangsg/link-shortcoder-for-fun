Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :links do
    collection do
      get :check
    end
  end

  get '/:id', controller: :links, action: :show
end
