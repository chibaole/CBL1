# == Schema Information
#
# Table name: promotions
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  started_at        :datetime
#  state             :integer          default("0")
#  expired_at        :datetime
#  message_template  :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  start_delivery_at :datetime
#

class Promotion < ApplicationRecord
  # 未开始: 0
  # 进行中: 1
  # 已过期: 2
  # 已失效: 3
  enum state: {not_start: 0, starting: 1, expired: 2, not_valid: 3}

  has_and_belongs_to_many :products
  has_many :code_batches

  validates :name, :started_at, :expired_at, :message_template, :start_delivery_at, presence: true

  def start_delivery_date
    if self.start_delivery_at && self.start_delivery_at > Time.now
      self.start_delivery_at.strftime("%F")
    else
      1.day.since.strftime("%F")
    end
  end

  def end_delivery_date
    self.expired_at.strftime("%F")
  end

  def expired_at_text
    self.expired_at.strftime("%Y年%m月%d日")
  end
end
