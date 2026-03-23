class Seller < User
  has_many :products, foreign_key: 'seller_id'
end
