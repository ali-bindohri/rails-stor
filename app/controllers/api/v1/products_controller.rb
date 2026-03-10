class Api::V1::ProductsController < ApplicationController
  before_action :authorize_request
  before_action :authorize_seller!, only: [:create]
  
  def index
    products = Product.all
    products = apply_filters(products, [:name, :price, :quantity, :seller_id])
    formatted_products =products.as_api_response(:index)
    render_success(data: {products: formatted_products})
  end

  def create 
    product = current_user.products.build(product_params)
      if product.save
        render_success(message: "Product created successfully", data: {product: {id: product.id, name: product.name, description: product.description, price: product.price, quantity: product.quantity, seller: {id: product.seller.id, email: product.seller.email}}})
      else
        render_error(message: product.errors.full_messages)
      end
  end
  

  private

  def product_params
    params.permit(:name, :description, :price, :quantity)
  end
end
