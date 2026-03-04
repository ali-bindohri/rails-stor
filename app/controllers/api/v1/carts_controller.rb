class Api::V1::CartsController < ApplicationController
  before_action :authorize_request
  before_action :authorize_customer!

  def add_item 
    cart = current_user.cart || current_user.create_cart
    product = Product.find_by(id: params[:product_id])
    return render_error(message: 'Product not found') unless product
    
    cart_item = cart.cart_items.find_or_create_by(product_id: product.id)
    cart_item.update(quantity: (cart_item.quantity || 0) + 1)

    render_success(message: 'Product added to cart')
  end

  def items 
    cart = current_user.cart
    return render json: { items: [], total_amount: 0 }, status: :ok unless cart

    total_amount = cart.cart_items.sum { |item| item.product.price * item.quantity }
    render_success(items: cart.cart_items, total_amount: total_amount)
  end

  def remove_item
    cart = current_user.cart
    return render json: { error: 'Cart is empty' }, status: :unprocessable_entity unless cart

    cart_item = cart.cart_items.find_by(product_id: params[:product_id])
    return render json: { error: 'Product not found in cart' }, status: :not_found unless cart_item
    
    cart_item.destroy
    render_success(message: 'Product removed from cart')
  end
end