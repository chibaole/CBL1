class CreatePromotionCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :promotion_codes do |t|
      t.references :code_batch, index: true
      t.string :code
      t.integer :state, default: 0

      t.timestamps
    end
  end
end
