Rails.application.routes.draw do
  scope Remindme.route_scope do
    resources :passwords, :except => [:index, :destroy]
  end
end
