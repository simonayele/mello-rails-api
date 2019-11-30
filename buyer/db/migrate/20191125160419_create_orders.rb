class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.decimal :total_price
      t.integer :user_id

      t.timestamps
    end

    add_index :orders, :user_id
  end
end
