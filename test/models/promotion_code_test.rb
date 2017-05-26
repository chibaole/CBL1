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

require 'test_helper'

class PromotionCodeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
