class AddCodeLengthToCodeBatches < ActiveRecord::Migration[5.0]
  def change
    add_column :code_batches, :code_length, :integer, default: 6
  end
end
