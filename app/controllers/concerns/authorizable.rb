module Authorizable
  extend ActiveSupport::Concern

  included do
    # Helper to ensure the current user is a Seller
    def authorize_seller!
      unless current_user&.type == 'Seller'
        render json: { error: 'You are not authorized to perform this action. Sellers only.' }, status: :unauthorized
      end
    end

    # Helper to ensure the current user is a Customer
    def authorize_customer!
      unless current_user&.type == 'Customer'
        render json: { error: 'You are not authorized to perform this action. Customers only.' }, status: :unauthorized
      end
    end
  end
end
