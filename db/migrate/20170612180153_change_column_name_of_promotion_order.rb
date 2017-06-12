class ChangeColumnNameOfPromotionOrder < ActiveRecord::Migration[5.0]
  def up
    rename_column :promotion_orders, :distinct, :district
  end

  def down
    rename_column :promotion_orders, :district, :distinct
  end
end
