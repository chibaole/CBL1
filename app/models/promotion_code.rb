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
  # 未使用: 0
  # 已使用: 1
  # 自动过期: 2
  # 手动实效: 3
  enum state: {unused: 0, used: 1, auto_expired: 2, manual_invalid: 3}
  belongs_to :code_batch
  has_one :promotion_order

  def gen_code(length=6)
    c = rand(10**length).to_s(10)
    while !self.class.where(code: c, state: 0).empty?
      c = rand(10**length).to_s(10)
    end
    self.code = c
  end

  def __to_s
    "#{self.class} [##{self.id}, code: #{self.code}]"
  end
end
