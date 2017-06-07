class ChangeDeliveryTimeForPromotions < ActiveRecord::Migration[5.0]
  def up
    remove_column :promotions, :start_delivery_at
    remove_column :promotions, :end_delivery_at
    add_column :promotions, :start_delivery_at, :datetime
  end

  def down
    add_column :promotions, :start_delivery_at, :time
    add_column :promotions, :end_delivery_at, :time
    remove_column :promotions, :start_delivery_at
  end
end
