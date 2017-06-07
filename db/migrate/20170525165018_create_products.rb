class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :count, default: 1
      t.string :specification
      t.string :image
      t.string :url

      t.timestamps
    end
  end
end
