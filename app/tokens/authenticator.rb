class Authenticator
  def self.token_for_login(email, password)
    user = UserRepository.find_by_email(email)
    if user && user.authenticate(password)
      return WebTokenManager.encode(user_id: user.id)
    else
      raise(ExceptionHandler::AuthenticationError, "Invalid credentials")
    end
  end
end
