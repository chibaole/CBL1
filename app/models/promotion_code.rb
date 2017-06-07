# == Schema Information
#
# Table name: promotion_codes
#
#  id            :integer          not null, primary key
#  code_batch_id :integer
#  code          :string(255)
#  state         :integer          default("0")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_promotion_codes_on_code_batch_id  (code_batch_id)
#

class PromotionCode < ApplicationRecord
  # 未兑换: 0
  # 已兑换: 1
  # 已完成: 2
  # 自动过期: 3
  # 手动失效: 4
  enum state: {unexchanged: 0, exchanged: 1, finished: 2, auto_expired: 3, manual_invalid: 4}

  STATE_TEXT = {
    'unexchanged'=> '未兑换',
    'exchanged'=> '已兑换',
    'finished'=> '已完成',
    'auto_expired'=> '自动失效',
    'manual_invalid'=> '手动失效'
  }

  belongs_to :code_batch
  delegate :expired_at, to: :code_batch, prefix: false, allow_nil: true
  delegate :promotion, to: :code_batch, prefix: false, allow_nil: true
  has_one :promotion_order

  validates :code_batch_id, :code, :state, presence: true

  scope :active, -> { where(state: [0, 1]) } # 在 [0, 1] 两种状态下，认为兑换码是激活的

  # 生成核销码
  # @length: integer
  def generate_code(length=6)
    c = rand(10**length).to_s(10)
    while !PromotionCode.active.where(code: c).empty?
      c = rand(10**length).to_s(10)
    end
    self.code = c
  end

  # 是否可以兑换
  def can_exchange?
    unless self.promotion.starting?
      return false
    end

    if self.unexchanged?
      if self.expired_at.nil?
        # NOTE: 如果没有过期时间，认为可以兑换
        true
      else
        self.expired_at > Time.now
      end
    else
      false
    end
  end

  def start_exchange_date
    if self.promotion.start_delivery_at && self.promotion.start_delivery_at > 1.day.since.beginning_of_day
        self.promotion.start_delivery_at.strftime("%F")
    else
      1.day.since.strftime("%F")
    end
  end

  def end_exchange_date

  end

  def __to_s
    "#{self.class} [##{self.id}, code: #{self.code}]"
  end
end
