module TokenSpecHelper
  def token_generator(user_id)
    WebTokenManager.encode(user_id: user_id)
  end

  def expired_token_generator(user_id)
    WebTokenManager.encode({ user_id: user_id }, (Time.now.to_i - 10))
  end

  def valid_headers(user_id)
    json_only_headers.merge({
      "Authorization" => token_generator(user_id),
    })
  end

  def json_only_headers
    {
      "Content-Type" => "application/json"
    }
  end

  def invalid_headers
    json_only_headers.merge({
      "Authorization" => nil,
    })
  end
end
