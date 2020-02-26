Rails.application.routes.draw do
  # get 'crawlers/index'

  resources :crawlers, only: [:index, :create]

  delete "clear" => "crawlers#destroy"

  get "crawlers/contact" => "crawlers#contact"

  root :to => redirect("/crawlers")

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
