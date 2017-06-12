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
#  guid                   :string(255)
#  province               :string(255)
#  city                   :string(255)
#  district               :string(255)
#
# Indexes
#
#  index_promotion_orders_on_promotion_code_id  (promotion_code_id)
#  index_promotion_orders_on_sf_order_id        (sf_order_id)
#

require 'test_helper'

class PromotionOrderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
