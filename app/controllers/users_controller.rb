class UsersController < ApplicationController
  skip_before_action :authenticate, only: [:create]

  def create
    user = UserRepository.create(user_params[:email], user_params[:password], user_params[:password_confirmation])
    auth_token = Authenticator.token_for_login(user.email, user.password)
    json_response({ auth_token: auth_token }, :created)
  end

  def show
    json_response(@current_user, :ok)
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
