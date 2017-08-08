class AuthenticationController < ApplicationController
  def create
    auth_token = Authenticator.token_for_login(auth_params[:email], auth_params[:password])
    json_response(auth_token: auth_token)
  end

  private

  def auth_params
    params.permit(:email, :password)
  end
end
