Rails.application.routes.draw do
  post 'api/v1/auth/login', to: 'authentication#create'
end
