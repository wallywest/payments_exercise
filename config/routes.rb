Rails.application.routes.draw do
  resources :loans, defaults: {format: :json} do
    resources :payments, only: [:show, :create, :index]
  end
end
