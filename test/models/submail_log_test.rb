# == Schema Information
#
# Table name: submail_logs
#
#  id               :integer          not null, primary key
#  msg_type         :integer          default("0")
#  send_id          :string(191)
#  submailable_id   :integer
#  submailable_type :string(191)
#  err_code         :string(191)      default("")
#  err_message      :string(191)      default("")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_submail_logs_on_msg_type          (msg_type)
#  index_submail_logs_on_send_id           (send_id)
#  index_submail_logs_on_submailable_id    (submailable_id)
#  index_submail_logs_on_submailable_type  (submailable_type)
#

require 'test_helper'

class SubmailLogTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
