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
end
