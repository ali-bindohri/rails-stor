class Product < ApplicationRecord
  belongs_to :seller, class_name: 'User'

  acts_as_api

  api_accessible :index do |template|
    template.add :id
    template.add :name
    template.add :price
    template.add :quantity
  end
  
end
