class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name, null: false, index: true, unique: true
      t.string :encrypted_password, null: false, default: ''
      t.string :auth_token, index: true, unique: true
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip

      # confirmable
      t.string :confirmation_token, index: true, unique: true
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at

      t.timestamps
    end
  end
end
