class Api::V1::SessionsController < ApplicationController
  def create
    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password])
      token = save_token_in_cookie(@user)
      time = Time.now + 24.hours.to_i
      data = { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
                     user: { id: @user.id, email: @user.email, type: @user.type } }
      render_success(data:data)
    else
      render_error(message: 'unauthorized')
    end
  end
  
  def destroy 
    clear_token_from_cookie
    render_success(message: 'logged out successfully')
  end
end
