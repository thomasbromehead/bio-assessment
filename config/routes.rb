Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope module: "api" do
    scope module: "v1" do
      post "shorten", to: "shortener#shorten"
      get "shortened", to: "shortener#show", as: :shortened_urls_path
    end
  end
end
