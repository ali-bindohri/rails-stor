class Api::V1::RegistrationsController < ApplicationController
  def create
    if params[:type] == 'Seller'
      @user = Seller.new(user_params)
    else
      @user = Customer.new(user_params)
    end

    if @user.save
      token = save_token_in_cookie(@user)
      time = Time.now + 24.hours.to_i
      data = { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
                     user: { id: @user.id, email: @user.email, type: @user.type } }
      render_success(data:data)
    else
      render_error(message: @user.errors.full_messages)
    end
  end

  private

  def user_params
    params.permit(
      :first_name, :last_name, :email, :password, :password_confirmation
    )
  end
end
