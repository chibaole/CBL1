class AddProvinceCityDistinctToPromotionOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :promotion_orders, :province, :string
    add_column :promotion_orders, :city, :string
    add_column :promotion_orders, :distinct, :string
  end
end
