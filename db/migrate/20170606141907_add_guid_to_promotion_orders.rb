class AddGuidToPromotionOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :promotion_orders, :guid, :string, index: true
  end
end
