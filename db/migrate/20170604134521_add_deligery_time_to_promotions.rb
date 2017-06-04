class AddDeligeryTimeToPromotions < ActiveRecord::Migration[5.0]
  def change
    add_column :promotions, :start_delivery_at, :time
    add_column :promotions, :end_delivery_at, :time
  end
end
