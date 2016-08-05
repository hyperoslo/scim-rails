SCIM::Engine.routes.draw do
  resources :users, path: 'Users', only: [:index, :create]
end
