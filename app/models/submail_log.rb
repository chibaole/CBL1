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

require 'message_sender'

class SubmailLog < ApplicationRecord
  enum msg_type: {message: 0}

  belongs_to :submailable, polymorphic: true

  def self.xsend(sender, phone_number, vars = {})
    Rails.logger.info "发送短信: #{phone_number}, @vars: #{vars}"

    message_sender = MessageSender.new(phone_number, '', vars)
    response = JSON.parse(message_sender.xsend())

    log = SubmailLog.new
    log.msg_type = SubmailLog.msg_types['message']
    log.submailable = sender

    if response["status"] == "sucess"
      log.send_id = response["send_id"]
      log.save
    else
      log.err_code = response["code"]
      log.err_message = response["msg"]
      log.save
    end
  end
end
