# == Schema Information
#
# Table name: code_batches
#
#  id           :integer          not null, primary key
#  promotion_id :integer
#  note         :string(255)
#  expired_at   :datetime
#  count        :integer          default("0")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  code_length  :integer          default("6")
#
# Indexes
#
#  index_code_batches_on_promotion_id  (promotion_id)
#

class CodeBatch < ApplicationRecord
  belongs_to :promotion
  has_many :promotion_codes

  # 生成核销码
  def generate_codes
    gened_size = self.promotion_codes.size
    (self.count - gened_size).times.each do |i|
      code = PromotionCode.new
      code.code_batch = self
      code.generate_code(self.code_length)
      code.save
    end
  end
end
