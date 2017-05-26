# == Schema Information
#
# Table name: products
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  count         :integer
#  specification :string(255)
#  image         :string(255)
#  url           :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Product < ApplicationRecord
  has_and_belongs_to_many :promotions
end
