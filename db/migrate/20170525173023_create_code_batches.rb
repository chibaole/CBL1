class CreateCodeBatches < ActiveRecord::Migration[5.0]
  def change
    create_table :code_batches do |t|
      t.references :promotion, index: true
      t.string :note
      t.datetime :expired_at
      t.integer :count, default: 0

      t.timestamps
    end
  end
end
