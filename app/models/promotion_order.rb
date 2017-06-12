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

class PromotionOrder < ApplicationRecord
  include Guidable
  # 未处理: 0
  # 已确认: 1
  # 已发货: 2
  # 已完成: 3
  enum state: {init: 0, confirmed: 1, shipping: 2, finished: 3}

  belongs_to :promotion_code
  delegate :code, to: :promotion_code, prefix: false, allow_nil: true
  delegate :promotion, to: :promotion_code, prefix: false, allow_nil: true
  has_many :submail_log, as: :submailable

  STATE_TEXT = {
    'init' => '未处理',
    'confirmed' => '已确认',
    'shipping' => '已发货',
    'finished' => '已完成'
  }

  def full_address
    "#{self.province}#{self.city}#{self.district}#{self.address}"
  end

  def reserved_delivery_date_text
    self.reserved_delivery_date.strftime("%Y年%m月%d日")
  end

  def created_at_text
    self.created_at.strftime("%Y年%m月%d日")
  end

  def notify_sms
    SubmailLog.xsend(self, self.customer_telephone, {
      code: self.code,
      promotion: self.promotion.name,
      url: self.guid
      })
  end

  private
  # override @generate_guid
  # 生成 年月日时分秒z毫秒(随机6六位数)的订单ID
  # 比如 20170607135852z180772430
  def generate_guid
    begin
      if self.guid.present?
        return
      end
      timestamp = Time.now.strftime("%Y%m%d%H%M%Sz%L")
      guid = "#{timestamp}#{rand(10**6).to_s(10)}"
      while !self.class.where(:guid => guid).empty?
        guid = "#{timestamp}#{rand(10**6).to_s(10)}"
      end
      self.guid = guid if self.guid.blank?

    rescue ActiveModel::MissingAttributeError

    end
  end
end
