class FixColumnsForProductsPromotions < ActiveRecord::Migration[5.0]
  def up
    remove_column :products_promotions, :products_id
    remove_column :products_promotions, :promotions_id

    add_column :products_promotions, :product_id, :integer
    add_column :products_promotions, :promotion_id, :integer
    add_index :products_promotions, :product_id
    add_index :products_promotions, :promotion_id
  end

  def down
    add_column :products_promotions, :products_id, :integer
    add_column :products_promotions, :promotions_id, :integer
    add_index :products_promotions, :products_id
    add_index :products_promotions, :promotions_id

    remove_column :products_promotions, :product_id, :integer
    remove_column :products_promotions, :promotion_id, :integer
  end
end
