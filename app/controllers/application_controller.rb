class ApplicationController < ActionController::API
  include TokenAuthenticatable
  include ActionController::Cookies
  include Filterable
  include Authorizable
  include ResponseRenderer

  def authorize_request
    # header = request.headers['Authorization']
    # header = header.split(' ').last if header
    # begin
    #   @decoded = JsonWebToken.decode(header)
    #   @current_user = User.find(@decoded[:user_id])
    # rescue ActiveRecord::RecordNotFound => e
    #   render json: { errors: e.message }, status: :unauthorized
    # rescue JWT::DecodeError => e
    #   render json: { errors: e.message }, status: :unauthorized
    # end
    token = cookies.signed[:token] || extract_token_from_header
    if token 
      begin 
        @decoded = JsonWebToken.decode(token)
        @current_user = User.find(@decoded[:user_id])
      rescue ActiveRecord::RecordNotFound => e
        render json: { errors: e.message }, status: :unauthorized
      rescue JWT::DecodeError => e
        render json: { errors: e.message }, status: :unauthorized
      end
    else
      render json: { errors: 'unauthorized' }, status: :unauthorized
    end
  end

  def extract_token_from_header 
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    header
  end
  
  def current_user
    return @current_user if @current_user
    token = cookies.signed[:token] || extract_token_from_header
    
    if token
      begin
        decoded = JsonWebToken.decode(token)
        @current_user = User.find_by(id: decoded[:user_id])
      rescue
        nil
      end
    end
    
    @current_user
  end
end
