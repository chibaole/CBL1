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

ActiveRecord::Schema.define(version: 20170612180153) do

  create_table "code_batches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "promotion_id"
    t.string   "note",         limit: 255
    t.datetime "expired_at"
    t.integer  "count",                    default: 0
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "code_length",              default: 6
    t.index ["promotion_id"], name: "index_code_batches_on_promotion_id", using: :btree
  end

  create_table "products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "name",          limit: 255
    t.integer  "count",                                              default: 1
    t.string   "specification", limit: 255
    t.string   "image",         limit: 255
    t.string   "url",           limit: 255
    t.datetime "created_at",                                                         null: false
    t.datetime "updated_at",                                                         null: false
    t.decimal  "price",                     precision: 10, scale: 2, default: "0.0"
  end

  create_table "products_promotions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "product_id"
    t.integer "promotion_id"
    t.index ["product_id"], name: "index_products_promotions_on_product_id", using: :btree
    t.index ["promotion_id"], name: "index_products_promotions_on_promotion_id", using: :btree
  end

  create_table "promotion_codes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "code_batch_id"
    t.string   "code",          limit: 255
    t.integer  "state",                     default: 0
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.index ["code_batch_id"], name: "index_promotion_codes_on_code_batch_id", using: :btree
  end

  create_table "promotion_orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "promotion_code_id"
    t.integer  "state"
    t.string   "customer_name",          limit: 255
    t.string   "customer_telephone",     limit: 255
    t.string   "address",                limit: 255
    t.datetime "reserved_delivery_date"
    t.string   "sf_order_id",            limit: 255
    t.string   "note",                   limit: 255
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "guid",                   limit: 255
    t.string   "province",               limit: 255
    t.string   "city",                   limit: 255
    t.string   "district",               limit: 255
    t.index ["promotion_code_id"], name: "index_promotion_orders_on_promotion_code_id", using: :btree
    t.index ["sf_order_id"], name: "index_promotion_orders_on_sf_order_id", using: :btree
  end

  create_table "promotions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "name",              limit: 255
    t.datetime "started_at"
    t.integer  "state",                         default: 0
    t.datetime "expired_at"
    t.string   "message_template",  limit: 255
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.datetime "start_delivery_at"
  end

  create_table "submail_logs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer  "msg_type",         default: 0
    t.string   "send_id"
    t.integer  "submailable_id"
    t.string   "submailable_type"
    t.string   "err_code",         default: ""
    t.string   "err_message",      default: ""
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["msg_type"], name: "index_submail_logs_on_msg_type", using: :btree
    t.index ["send_id"], name: "index_submail_logs_on_send_id", using: :btree
    t.index ["submailable_id"], name: "index_submail_logs_on_submailable_id", using: :btree
    t.index ["submailable_type"], name: "index_submail_logs_on_submailable_type", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "name",                 limit: 255,              null: false
    t.string   "encrypted_password",   limit: 255, default: "", null: false
    t.string   "auth_token",           limit: 255
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",   limit: 255
    t.string   "last_sign_in_ip",      limit: 255
    t.string   "confirmation_token",   limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.index ["auth_token"], name: "index_users_on_auth_token", using: :btree
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", using: :btree
    t.index ["name"], name: "index_users_on_name", using: :btree
  end

end
