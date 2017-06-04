module AdminRecord
  extend ActiveSupport::Concern

  included do
    extend ClassMethods
  end

  def __to_s
    "#{self.try(:title) || self.try(:name) || self.class.to_s}[##{self.id}]"
  end

  module ClassMethods
    # 获得所有关系属性
    def association_attributes
      name = ''
      attr_name = ''
      column_name = ''
      if self.respond_to? :reflect_on_all_associations
        self.reflect_on_all_associations.map do |reflection|

          r = reflection

          if r.class.to_s.demodulize == 'ThroughReflection'
            r = r.delegate_reflection
          end

          name = r.class.to_s.demodulize
          attr_name = r.name.to_s
          column_name = "#{attr_name}_id" if r.belongs_to?
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

    # 关系属性
    def u_assicoate_attrs
      if self.respond_to? :reflect_on_all_associations
        self.reflect_on_all_associations.map do |reflection|
          name = reflection.class.to_s.demodulize
          attr_name = reflection.name.to_s
          column_name = "#{attr_name}_id" if reflection.belongs_to?
          {
            attr_type: name,
            attr_name: attr_name,
            column_name: column_name
          }
        end
      else
        []
      end
    end

    # 所有属性
    def u_attrs
      ass_attrs = u_assicoate_attrs
      attrs = attribute_names
      attrs = (attrs - ass_attrs.map{|a| a[:column_name]})
      attrs = attrs.map{|a| {attr_type: 'Normal', column_name: a, attr_name: a} } + ass_attrs
      attrs
    end

    # 包含 sql_type 的属性
    def u_attrs_with_sql_type
      column_attrs = self.columns_hash
      h = {}
      u_attrs.each do |attr|
        h[attr[:attr_name]] = {
          attr_type: attr[:attr_type],
          attr_name: attr[:attr_name],
          sql_type: column_attrs[attr[:column_name]].try(:type) || ""
        }
      end
      h
    end

    # 属性以及类型
    def attributes_with_type
      column_attrs = self.columns_hash
      h = {}
      all_attributes.each do |attr|
        h[attr[:column_name]] = {
          attr_type: attr[:name],
          attr_name: attr[:attr_name],
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
end
