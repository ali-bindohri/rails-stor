class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.references :customer, null: false, foreign_key: { to_table: :users }
      t.decimal :total_amount
      t.string :status

      t.timestamps
    end
  end
end
