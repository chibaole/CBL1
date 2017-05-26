class CreatePromotions < ActiveRecord::Migration[5.0]
  def change
    create_table :promotions do |t|
      t.string :name
      t.datetime :started_at
      t.integer :state, default: 0
      t.datetime :expired_at
      t.string :message_template

      t.timestamps
    end
  end
end
