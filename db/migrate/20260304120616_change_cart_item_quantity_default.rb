class ChangeCartItemQuantityDefault < ActiveRecord::Migration[8.1]
  def change
    CartItem.where(quantity: nil).update_all(quantity: 0)
    change_column_default :cart_items, :quantity, from: nil, to: 0
  end
end
