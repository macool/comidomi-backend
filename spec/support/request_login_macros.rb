module RequestLoginMacros
  def login_as(user)
    post(
      api_auth_user_session_path,
      email: user.email,
      password: user.password
    )
  end

  def post_with_headers(path, parameters = {})
    post(path, parameters, response_headers)
  end

  def get_with_headers(path)
    get(path, response_headers)
  end

  def put_with_headers(path, parameters = {})
    put(path, parameters, response_headers)
  end

  private

  def response_headers
    response.headers.slice(
      "access-token",
      "token-type",
      "client",
      "expiry",
      "uid"
    )
  end
end
