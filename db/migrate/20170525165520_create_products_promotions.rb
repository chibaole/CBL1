class CreateProductsPromotions < ActiveRecord::Migration[5.0]
  def change
    create_table :products_promotions do |t|
      t.references :products, index: true
      t.references :promotions, index: true
    end
  end
end
