class Customer < User
  has_one :cart, foreign_key: 'customer_id' 

end
