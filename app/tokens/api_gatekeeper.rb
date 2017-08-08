class ApiGatekeeper
  def self.verify_user(headers)
    auth_headers = http_auth_header(headers)
    decoded_token = WebTokenManager.decode(auth_headers)
    UserRepository.find(decoded_token[:user_id]).tap do |user|
      raise(ExceptionHandler::InvalidToken, "Invalid token") unless user
    end
  end

  def self.http_auth_header(headers)
    if headers['Authorization'].present?
      return headers['Authorization'].split(' ').last
    end
    raise(ExceptionHandler::MissingToken, "Missing token")
  end
  private_class_method :http_auth_header

end
