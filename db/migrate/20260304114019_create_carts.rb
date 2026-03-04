class CreateCarts < ActiveRecord::Migration[8.1]
  def change
    create_table :carts do |t|
      t.references :customer, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
