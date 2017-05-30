module Admin
  module DelegateHelper
    MAX_ATTR_LENGTH = 15
    # @resource_model: ShopItem
    # @resource_name: shop_item
    # @resource: <ShopItem: 231231231>

    def delegate_next_attr_button_tag
      link_to delegate_resources_path(attr_page: attr_page + 1), class: 'ui button' do
        '<i class="angle right icon"></i>'.html_safe
      end
    end

    def delegate_prev_attr_button_tag
      link_to delegate_resources_path(attr_page: attr_page - 1), class: 'ui button' do
        '<i class="angle left icon"></i>'.html_safe
      end
    end

    def delegate_new_resource_button_tag
      link_to '新建', self.send("new_admin_delegate_#{@resource_name}_path"), class: 'ui primary button'
    end

    def delegate_edit_resource_button_tag(resource)
      link_to '编辑', self.send("edit_admin_delegate_#{@resource_name}_path", resource), class: 'ui button '
    end

    def delegate_show_resource_button_tag(resource)
      link_to '详情', self.send("admin_delegate_#{@resource_name}_path", resource), class: 'ui button'
    end

    def delegate_destroy_resource_button_tag(resource)
      link_to "删除", self.send("admin_delegate_#{@resource_name}_path", resource), method: :delete, class: 'ui red button', data: {confirm: 'Are you sure?' }
    end

    def delegate_resource_collection_buttons_tag
      buttons = []
      AdminConfig.collection_actions(@resource_name).each do |action|
        buttons << (link_to action.text, self.send("#{action.name}_admin_delegate_#{@resource_name}_path"), method: action.method, class: 'ui button')
      end
      buttons.join("").html_safe
    end

    def delegate_resource_member_buttons_tag(resource)
      buttons = ""
      buttons = "<div class='ui floating dropdown icon button'><i class='dropdown icon'></i><div class='menu'>"
      AdminConfig.member_actions(@resource_name).each do |action|
        buttons << (link_to action.text, self.send("#{action.name}_admin_delegate_#{@resource_name}_path", resource), method: action.method, class: 'item')
      end
      buttons << "</div></div>"
      buttons.html_safe
    end

    def delegate_menu_item_tag(model, name)
      <<-FOO
        <a class="item" href="/admin/delegate/#{model}">#{name.presence || model}</a>
      FOO
      .html_safe
    end

    def delegate_resource_attr_tag(resource, attribute)
      case attribute[:name]
      when 'Normal'
        <<-FOO
          <div class="two wide column">
            <p class="admin-attr-name">#{ attribute[:attr_name].humanize.upcase } </p>
          </div>
          <div class="fourteen wide column">
            <p class="admin-attr-val">#{ resource.send(attribute[:column_name]) }</p>
          </div>
        FOO
        .html_safe
      when 'HasOneReflection'
        <<-FOO
          <div class="two wide column">
            <p class="admin-attr-name">#{ attribute[:attr_name].humanize.upcase } </p>
          </div>
          <div class="fourteen wide column">
            <p class="admin-attr-val">#{resource.send(attribute[:attr_name]).try(:name) || resource.send(attribute[:attr_name]).try(:title) || attribute[:attr_name].upcase} #{resource.id}</p>
          </div>
        FOO
        .html_safe
      when 'HasManyReflection'
        <<-FOO
          <div class="two wide column">
            <p class="admin-attr-name">#{ attribute[:attr_name].humanize.upcase } </p>
          </div>
          <div class="fourteen wide column">
            <p class="admin-attr-val">HasMany</p>
          </div>
        FOO
        .html_safe
      when 'BelongsToReflection'
        <<-FOO
          <div class="two wide column">
            <p class="admin-attr-name">#{ attribute[:attr_name].humanize.upcase } </p>
          </div>
          <div class="fourteen wide column">
            <p class="admin-attr-val">#{resource.send(attribute[:attr_name]).try(:name) || resource.send(attribute[:attr_name]).try(:title) || attribute[:attr_name].upcase} #{resource.id}</p>
          </div>
        FOO
        .html_safe
      else
        '------'
      end
    end

    def delegate_resource_attribute(resource, attribute)
      if resource.respond_to?("remote_#{attribute}_url")
        value = resource.send("#{attribute}_url")
      else
        value = resource.send(attribute)
      end

      if value.nil?
        return value
      end

      case @resource_model.columns_hash[attribute].type
      when :string
        if value.size <= MAX_ATTR_LENGTH
          value
        else
          "#{value.first(MAX_ATTR_LENGTH)}..."
        end
      when :text
        if value.size <= MAX_ATTR_LENGTH
          value
        else
          "#{value.first(MAX_ATTR_LENGTH)}..."
        end
      when :integer
        value
      when :float
        value
      when :datetime
        value.strftime('%F %H:%M:%S')
      else
        "属性类型未知!"
      end
    end

    def delegate_form_field_tag(f, resource, attribute)
      if @resource_model.defined_enums[attribute]
        f.select attribute, options_for_select(@resource_model.defined_enums[attribute].collect{|k,v| [k,k]}, resource.send(attribute)), {}, allow_nil: false, class: 'ui dropdown'
      else
        attrs = @resource_model.attributes_with_type
        if attrs[attribute][:attr_type] == 'Normal'
          case attrs[attribute][:sql_type]
          when :string
            # 测试是否是carrierwave uploader
            if resource.respond_to?("remote_#{attribute}_url")
              f.file_field attribute
            else
              f.text_field attribute
            end
          when :text
            if resource.respond_to?("remote_#{attribute}_url")
              f.file_field attribute
            else
              f.text_area attribute
            end
          when :integer
            f.number_field attribute
          when :float
            f.number_field attribute
          when :datetime
            f.text_field attribute, class: 'datepicker'
          else
            f.text_field attribute
          end
        else
          case attrs[attribute][:attr_type]
          when 'HasOneReflection'
            ""
          when 'HasManyReflection'
            ""
          when 'BelongsToReflection'
            model = attrs[attribute][:attr_name].classify.constantize
            f.select attribute, options_for_select(model.all.map{|m| ["#{model.to_s}#{m.id}", m.id]}, resource.send(attribute)), {}, allow_nil: false, class: 'ui dropdown'
          else
          end
        end
      end
    end

    def delegate_form_url(resource)
      if resource.new_record?
        delegate_resources_path
      else
        delegate_resource_path(resource)
      end
    end

    def delegate_form_method(resource)
      if resource.new_record?
        :post
      else
        :patch
      end
    end

    def delegate_resources_path(options = {})
      self.send("admin_delegate_#{@resource_name.pluralize}_path", options)
    end

    def delegate_resource_path(options = {})
      self.send("admin_delegate_#{@resource_name}_path", @resource, options)
    end

    def delegate_edit_resource_path(options = {})
      self.send("edit_admin_delegate_#{@resource_name}_path", @resource, options)
    end
  end
end
