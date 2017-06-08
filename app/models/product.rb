# == Schema Information
#
# Table name: products
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  count         :integer          default("1")
#  specification :string(255)
#  image         :string(255)
#  url           :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  price         :decimal(10, 2)   default("0.00")
#

class Product < ApplicationRecord
  mount_uploader :image, ImageLocalUploader

  has_and_belongs_to_many :promotions
  validates :name, length: { maximum: 50, too_long: "最长%{count}个字"}
  validates :specification, length: { maximum: 50, too_long: "最长%{count}个字"}
  validates :name, :count, :specification, :image, presence: true
end
