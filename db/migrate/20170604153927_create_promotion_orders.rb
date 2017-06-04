class CreatePromotionOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :promotion_orders do |t|
      t.references :promotion_code, index: true
      t.integer :state, integer: 0
      t.string :customer_name
      t.string :customer_telephone
      t.string :address
      t.datetime :reserved_delivery_date
      t.string :sf_order_id, index: true
      t.string :note

      t.timestamps
    end
  end
end
