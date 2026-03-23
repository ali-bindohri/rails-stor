class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.integer :quantity
      t.references :seller, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
