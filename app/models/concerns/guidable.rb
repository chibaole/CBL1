module Guidable
  extend ActiveSupport::Concern

  included do
    after_initialize :generate_guid
  end

  def to_param
    self.guid
  end

  private
  
  def generate_guid
    begin
      if self.guid.present?
        return
      end
      guid = rand(36**12).to_s(36)
      while !self.class.where(:guid => guid).empty?
        guid = rand(36**12).to_s(36)
      end
      self.guid = guid if self.guid.blank?

    rescue ActiveModel::MissingAttributeError
    end
  end
end
