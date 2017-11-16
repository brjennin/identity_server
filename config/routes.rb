Rails.application.routes.draw do
    scope "api/v1" do
      post "authentication", to: "authentication#create"
      post "signup", to: "users#create"
      get "test", to: "test#index"
    end
end
