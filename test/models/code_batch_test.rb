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
#
# Indexes
#
#  index_code_batches_on_promotion_id  (promotion_id)
#

require 'test_helper'

class CodeBatchTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
