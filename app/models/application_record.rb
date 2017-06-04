class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  include AdminRecord

  class << self
    # 获得所有关系属性
    def association_attributes
      name = ''
      attr_name = ''
      column_name = ''
      if self.respond_to? :reflect_on_all_associations
        self.reflect_on_all_associations.map do |reflection|
          name = reflection.class.to_s.demodulize
          attr_name = reflection.name.to_s
          column_name = "#{attr_name}_id" if reflection.belongs_to?
          {
            name: name,
            attr_name: attr_name,
            column_name: column_name
          }
        end
      else
        []
      end
    end

    # 属性以及类型
    def attributes_with_type
      column_attrs = self.columns_hash
      h = {}
      all_attributes.each do |attr|
        h[attr[:attr_name]] = {
          attr_type: attr[:name],
          column_name: attr[:column_name],
          sql_type: column_attrs[attr[:column_name]].try(:type) || ""
        }
      end
      h
    end

    # 获得所有属性
    def all_attributes
      ass = association_attributes
      attrs = attribute_names
      attrs = (attrs - ass.map{|a| a[:column_name]})
      attrs = attrs.map{|a| {name: 'Normal', column_name: a, attr_name: a} } + ass
      attrs
    end
  end

  # instance methods
  def to_str
    "#{self.name || self.title || self.id}#(self.id)"
  end
end
