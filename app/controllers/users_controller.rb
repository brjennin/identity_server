class UsersController < ApplicationController
  def create
    user = UserRepository.create(user_params[:email], user_params[:password], user_params[:password_confirmation])
    auth_token = Authenticator.token_for_login(user.email, user.password)
    json_response({ auth_token: auth_token }, :created)
  end

  private

  def user_params
    params.permit(
      :email,
      :password,
      :password_confirmation
    )
  end
end
