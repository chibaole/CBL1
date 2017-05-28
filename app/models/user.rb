# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  name                 :string(255)      not null
#  encrypted_password   :string(255)      default(""), not null
#  auth_token           :string(255)
#  current_sign_in_at   :datetime
#  last_sign_in_at      :datetime
#  current_sign_in_ip   :string(255)
#  last_sign_in_ip      :string(255)
#  confirmation_token   :string(255)
#  confirmed_at         :datetime
#  confirmation_sent_at :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_users_on_auth_token          (auth_token)
#  index_users_on_confirmation_token  (confirmation_token)
#  index_users_on_name                (name)
#

class User < ApplicationRecord
  include BCrypt

  def password
    @password ||= Password.new(self.encrypted_password)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.encrypted_password = @password
  end

  def confirm!
    self.confirmation_token = nil
    self.confirmed_at = Time.now
    self.save!
  end

  private

  def genereate_confirmation_token
    loop do
      token = SecureRandom.urlsafe_base64
      unless User.where(confirmation_token: token).any?
        self.confirmation_token = token
        self.confirmation_sent_at = Time.now.utc
        break
      end
    end
  end
end
