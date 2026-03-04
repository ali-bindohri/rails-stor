class CheckoutService

  def initialize(customer)
    @customer = customer
    @cart = customer.cart
  end

  def call
    return { success: false, error: 'Cart is empty' } if @cart.nil? || @cart.cart_items.empty?
    return { success: false, error: 'Not enough stock for some products' } unless stock_available?
    
    total = calculate_total
    order = nil
    
    ApplicationRecord.transaction do 
      order = Order.create(customer:@customer, total_amount:total, status:'pending')

      @cart.cart_items.each do |item| 
        product = item.product
        seller = product.seller

        product.update!(quantity: product.quantity - item.quantity)
        seller.update!(balance: seller.balance + item.product.price * item.quantity)
        
      end 
  
      @cart.cart_items.destroy_all
    end

    { success: true, order: order }

    rescue ActiveRecord::RecordInvalid => e 
      { success: false, error: e.record.errors.full_messages.join(', ') }
  end

  private

  def calculate_total
    @cart.cart_items.sum do |item|
      item.product.price * item.quantity
    end 
  end

  def stock_available?
    @cart.cart_items.all? do |item|
      item.product.quantity >= item.quantity
    end
  end
end
