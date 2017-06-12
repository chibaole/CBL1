module AdminRecord
  extend ActiveSupport::Concern

  included do
    extend ClassMethods
  end

  def __to_s
    "#{self.try(:title) || self.try(:name) || self.class.to_s}[##{self.id}]"
  end

  module ClassMethods
    #
    def __search(q = "", options = {})
      default = {
        fields: []
      }

      options.reverse_merge!(default)

      if options[:fields].empty?
        options[:fields] = self.columns_hash.select{|k, v| v.type == :text || v.type == :string }.map{|k, v| v.name }
      end

      query_string = []
      query_values = []

      if options[:fields].size == 0
        return self.all
      end

      options[:fields].each do |field|
        query_string << "#{field} LIKE ? "
        query_values << "%#{q}%"
      end
      
      self.where(query_string.join(" OR "), *query_values)
    end


    # 关系属性
    # 返回：
    # [
    #   {
    #     attr_type: '',
    #     attr_name: '',
    #     column_name: ''
    #   }
    # ]
    def __assicoate_attrs
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
    # 返回:
    # [
    #   {
    #     attr_type: '',
    #     column_name: '',
    #     attr_name: ''
    #   }
    # ]
    def __attrs
      ass_attrs = __assicoate_attrs
      attrs = attribute_names
      attrs = (attrs - ass_attrs.map{|a| a[:column_name]})
      attrs = attrs.map{|a| {attr_type: 'Normal', column_name: a, attr_name: a} } + ass_attrs
      attrs
    end

    def __normal_attrs
      __attrs.select{|a| a[:attr_type] == 'Normal' }
    end

    # 包含 sql_type 的属性
    # 返回:
    # {
    #   'attr_name': {
    #     attr_type: 'Normal',
    #     attr_name: '',
    #     sql_type: '',
    #     column_name: ''
    #   }
    # }
    def __attrs_with_sql_type
      column_attrs = self.columns_hash
      h = {}
      __attrs.each do |attr|
        h[attr[:attr_name]] = {
          attr_type: attr[:attr_type],
          attr_name: attr[:attr_name],
          sql_type: column_attrs[attr[:column_name]].try(:type) || "",
          column_name: attr[:column_name]
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
