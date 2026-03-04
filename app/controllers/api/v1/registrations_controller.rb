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
      render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
                     user: { id: @user.id, email: @user.email, type: @user.type } }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(
      :first_name, :last_name, :email, :password, :password_confirmation
    )
  end
end
