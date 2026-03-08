module TokenAuthenticatable
  extend ActiveSupport::Concern
  def save_token_in_cookie(user)
    token = JsonWebToken.encode(user_id: user.id)
    cookies.signed[:token] = {
      value: token,
      expires:24.hours.from_now,
      httponly: true,
      secure: Rails.env.production?
    }
    token
  end 
  def clear_token_from_cookie
    cookies.delete(:token)
  end
end