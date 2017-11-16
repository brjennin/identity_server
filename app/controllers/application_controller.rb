class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler

  before_action :authenticate

  def authenticate
    @current_user = ApiGatekeeper.verify_user(request.headers)
  end
end
