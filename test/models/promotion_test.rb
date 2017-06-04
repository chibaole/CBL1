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
#  start_delivery_at :time
#  end_delivery_at   :time
#

require 'test_helper'

class PromotionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
