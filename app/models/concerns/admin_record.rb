module AdminRecord
  extend ActiveSupport::Concern

  included do
    extend ClassMethods
    include InstanceMethods
  end

  module InstanceMethods
    def _to_s
      "#{self.name || self.title || self.class.to_s}#(#{self.guid || self.id})"
    end
  end

  module ClassMethods
    def _convert_attr_type(str)
      case str
      when 'Normal'
        :normal
      when 'HasMany'
        :has_many
      when 'BelongsTo'
        :belongs_to
      when 'HasOne'
        :has_one
      when 'HasAndBelongsToMany'
        :habtm
      else
        :unknown
      end
    end

    # 返回所有的属性
    # {
    #   attr_name: {
    #     attr_type: :normal, :habtm, :belongs_to, :has_many, :has_one,
    #     sql_type: :integer,
    #     column_name: ''
    #   }
    # }
    def _attributes
      asso_attrs = _associate_attributes
      asso_names = asso_attrs.map{|k,v| v[:column_name]}

      attrs = attribute_names - asso_names
      columns = self.columns_hash


    end

    # 返回所有的关系属性
    # {
    #   attr_name: {
    #     attr_type: :normal, :habtm, :belongs_to, :has_many, :has_one,
    #     sql_type: :integer,
    #     column_name: ''
    #   }
    # }
    def _associate_attributes
      attrs = {}

      if self.respond_to? :reflect_on_all_associations
        self.reflect_on_all_associations.each do |reflection|
          attrs[reflection.name.to_s] = {
            attr_type: _convert_attr_type(reflection.class.to_s.demodulize),
            column_name: reflection.belongs_to? ? "#{attr_name}_id" : "",
            sql_type: nil
          }
        end
      end
      attrs
    end

    def _attribute_names

    end
  end
end
