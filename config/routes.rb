Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope module: "api" do
    scope module: "v1" do
      post "shorten",  to: "shortener#shorten"
      get "index", to: "shortener#index", as: :shortened_urls
      get 'create',    to: "shortener#create"
      get 'show', to: "shortener#show/:url"
    end
  end
end
