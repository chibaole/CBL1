# == Schema Information
#
# Table name: promotions
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  started_at       :datetime
#  state            :integer          default("0")
#  expired_at       :datetime
#  message_template :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Promotion < ApplicationRecord
  # 未开始: 0
  # 进行中: 1
  # 已过期: 2
  # 已失效: 3
  enum state: {not_start: 0, starting: 1, expired: 2, void: 3}

  has_and_belongs_to_many :products
  has_many :code_batches
end
