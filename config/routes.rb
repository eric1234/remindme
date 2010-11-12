Rails.application.routes.draw do
  resources :passwords, :except => [:index, :destroy]
end
