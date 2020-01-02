Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/health', to: 'health#health'

  #Método utilitario para definir los elementos CRUD de un modelo
  #En este caso solo estamos interesados en el index y en el show
  resources :posts, only: [:index, :show, :create, :update]
end
