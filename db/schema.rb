# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170604134521) do

  create_table "code_batches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "promotion_id"
    t.string   "note"
    t.datetime "expired_at"
    t.integer  "count",        default: 0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "code_length",  default: 6
    t.index ["promotion_id"], name: "index_code_batches_on_promotion_id", using: :btree
  end

  create_table "products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "name"
    t.integer  "count"
    t.string   "specification"
    t.string   "image"
    t.string   "url"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "products_promotions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "product_id"
    t.integer "promotion_id"
    t.index ["product_id"], name: "index_products_promotions_on_product_id", using: :btree
    t.index ["promotion_id"], name: "index_products_promotions_on_promotion_id", using: :btree
  end

  create_table "promotion_codes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "code_batch_id"
    t.string   "code"
    t.integer  "state",         default: 0
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["code_batch_id"], name: "index_promotion_codes_on_code_batch_id", using: :btree
  end

  create_table "promotions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "name"
    t.datetime "started_at"
    t.integer  "state",             default: 0
    t.datetime "expired_at"
    t.string   "message_template"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.time     "start_delivery_at"
    t.time     "end_delivery_at"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "name",                              null: false
    t.string   "encrypted_password",   default: "", null: false
    t.string   "auth_token"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["auth_token"], name: "index_users_on_auth_token", using: :btree
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", using: :btree
    t.index ["name"], name: "index_users_on_name", using: :btree
  end

end
