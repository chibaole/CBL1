class CreateSubmailLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :submail_logs do |t|
      t.integer :msg_type, index: true, default: 0
      t.string :send_id, index: true
      t.integer :submailable_id, index: true
      t.string :submailable_type, index: true
      t.string :err_code, default: ''
      t.string :err_message, default: ''

      t.timestamps
    end
  end
end
