# == Schema Information
#
# Table name: promotion_orders
#
#  id                     :integer          not null, primary key
#  promotion_code_id      :integer
#  state                  :integer
#  customer_name          :string(255)
#  customer_telephone     :string(255)
#  address                :string(255)
#  reserved_delivery_date :datetime
#  sf_order_id            :string(255)
#  note                   :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_promotion_orders_on_promotion_code_id  (promotion_code_id)
#  index_promotion_orders_on_sf_order_id        (sf_order_id)
#

class PromotionOrder < ApplicationRecord
  # 未处理: 0
  # 发货中: 1
  # 已失效: 2
  enum state: {not_processed: 0, shipping: 1, not_valid: 2}

  belongs_to :promotion_code
end
