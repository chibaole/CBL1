module Admin
  module DelegateHelper
    MAX_ATTR_LENGTH = 15
    # @__resource_model: ShopItem
    # @__resource_name: shop_item
    # @_resource: <ShopItem: 231231231>

    # enum
    def deletage_resource_enum_tab
      menus = ""
      @__resource_model.defined_enums.each do |k, enums|
        menus << "<div class='ui grey inverted menu'>"
        menus << %Q(
        <a class="item" href="#{delegate_resources_path}">
          Clear #{k}
        </a>
        )
        enums.each do |enum|
          menus << %Q(
          <a class="item" href="#{delegate_resources_path(Hash[k, enum[0]])} ">
            #{enum[0]}
          </a>
          )
        end
        menus << "</div>"
      end
      menus.html_safe
    end

    # 属性下一页按钮
    def delegate_next_attr_button_tag
      link_to delegate_resources_path(attr_page: attr_page + 1), class: 'ui button' do
        '<i class="angle right icon"></i>'.html_safe
      end
    end

    # 属性上一页按钮
    def delegate_prev_attr_button_tag
      link_to delegate_resources_path(attr_page: attr_page - 1), class: 'ui button' do
        '<i class="angle left icon"></i>'.html_safe
      end
    end

    # 新建按钮
    def delegate_new_resource_button_tag
      link_to '新建', self.send("new_admin_delegate_#{@__resource_name}_path"), class: 'ui primary button'
    end

    # 编辑按钮
    def delegate_edit_resource_button_tag(resource)
      link_to '编辑', self.send("edit_admin_delegate_#{@__resource_name}_path", resource), class: 'ui button'
    end

    # 详情按钮
    def delegate_show_resource_button_tag(resource)
      link_to '详情', self.send("admin_delegate_#{@__resource_name}_path", resource), class: 'ui button'
    end

    # 删除按钮
    def delegate_destroy_resource_button_tag(resource)
      link_to "删除", self.send("admin_delegate_#{@__resource_name}_path", resource), method: :delete, class: 'ui red button', data: {confirm: 'Are you sure?' }
    end

    # 所有非对象操作按钮
    def delegate_resource_collection_buttons_tag
      buttons = []
      AdminConfig.collection_actions(@__resource_name).each do |action|
        buttons << (link_to action.text, self.send("#{action.name}_admin_delegate_#{@__resource_name}_path"), method: action.method, class: 'ui button')
      end
      buttons.join("").html_safe
    end

    # 所有对象操作按钮
    def delegate_resource_member_dropdown_tag(resource)
      buttons = ""
      buttons = "<div class='ui floating dropdown icon button'><i class='dropdown icon'></i><div class='menu'>"
      AdminConfig.member_actions(@__resource_name).each do |action|
        buttons << (link_to action.text, self.send("#{action.name}_admin_delegate_#{@__resource_name}_path", resource), method: action.method, class: 'item')
      end
      buttons << "</div></div>"
      buttons.html_safe
    end

    def delegate_resource_member_button_tags(resource)
      buttons = ""
      AdminConfig.member_actions(@__resource_name).each do |action|
        buttons << (link_to action.text, self.send("#{action.name}_admin_delegate_#{@__resource_name}_path", resource), method: action.method, class: 'ui button')
      end
      buttons.html_safe
    end

    # 侧边栏菜单
    # model: String, 'promotion_orders'
    # name: String, '订单管理'
    def delegate_menu_item_tag(model, name)
      <<-FOO
        <a class="item" href="/admin/delegate/#{model}">#{name.presence || model}</a>
      FOO
      .html_safe
    end

    # 类似HasMany这样的属性
    def delegate_list_attr_tag(resource, attribute)
      html = ""
      resource.send(attribute[:attr_name]).first(10).each do |c|
        html << %Q(
          <div class="item">
            <div class="content">
              #{c.__to_s}
            </div>
          </div>
        )
      end
      html.html_safe
    end

    # resource 属性 Tag
    def delegate_resource_attr_tag(resource, attribute)
      case attribute[:attr_type]
      when 'Normal'
        <<-FOO
          <div class="two wide column">
            <p class="admin-attr-name">#{ attribute[:attr_name].humanize.upcase } </p>
          </div>
          <div class="fourteen wide column">
            <p class="admin-attr-val">#{ html_escape(delegate_attribute_value(resource, attribute)) }</p>
          </div>
        FOO
        .html_safe
      when 'HasOneReflection'
        <<-FOO
          <div class="two wide column">
            <p class="admin-attr-name">#{ attribute[:attr_name].humanize.upcase } </p>
          </div>
          <div class="fourteen wide column">
            <p class="admin-attr-val">#{resource.__to_s}</p>
          </div>
        FOO
        .html_safe
      when 'HasManyReflection'
        <<-FOO
          <div class="two wide column">
            <p class="admin-attr-name">#{ attribute[:attr_name].humanize.upcase } </p>
          </div>
          <div class="fourteen wide column">
            <div class="ui middle aligned divided list">
              #{delegate_list_attr_tag(resource, attribute)}
            </div>
          </div>
        FOO
        .html_safe
      when 'BelongsToReflection'
        <<-FOO
          <div class="two wide column">
            <p class="admin-attr-name">#{ attribute[:attr_name].humanize.upcase } </p>
          </div>
          <div class="fourteen wide column">
            <p class="admin-attr-val">#{resource.send(attribute[:attr_name]).__to_s}</p>
          </div>
        FOO
        .html_safe
      when 'HasAndBelongsToManyReflection'
        <<-FOO
          <div class="two wide column">
            <p class="admin-attr-name">#{ attribute[:attr_name].humanize.upcase } </p>
          </div>
          <div class="fourteen wide column">
            <div class="ui middle aligned divided list">
              #{delegate_list_attr_tag(resource, attribute)}
            </div>
          </div>
        FOO
        .html_safe
      else
        "---------#{attribute[:attr_name]}----------"
      end
    end

    # 属性类型
    def delegate_attribute_value(resource, attribute, options = {})
      default = {
        is_list: false
      }
      options.reverse_merge!(default)

      value = resource.send(attribute[:attr_name])

      if value.is_a?(CarrierWave::Uploader::Base)
        value = resource.send("#{attribute[:attr_name]}_url")
      end

      if value.nil?
        return value
      end

      case attribute[:sql_type]
      when :string
        if options[:is_list] && value.size > MAX_ATTR_LENGTH
          "#{value.first(MAX_ATTR_LENGTH)}..."
        else
          value
        end
      when :text
        if options[:is_list] && value.size > MAX_ATTR_LENGTH
          "#{value.first(MAX_ATTR_LENGTH)}..."
        else
          value
        end
      when :integer
        value
      when :float
        value
      when :datetime
        value.strftime('%F %H:%M:%S')
      when :time
        value.strftime('%H:%M:%S')
      else
        "未知类型: #{attribute[:sql_type]}, 值: #{value}"
      end
    end

    # 属性的FormTag
    def delegate_form_field_tag(f, resource, attribute)
      if attribute.is_a?(String)
        attribute = @__resource_model.__attrs_with_sql_type[attribute]
      end

      if attribute.nil?
        return "---属性不存在---"
      end

      column_field = ''
      if @__resource_model.defined_enums[attribute[:attr_name]]
        f.select attribute[:attr_name], options_for_select(@__resource_model.defined_enums[attribute[:attr_name]].collect{|k,v| [k,k]}, resource.send(attribute[:attr_name])), {}, allow_nil: false, class: 'ui dropdown'
      else
        if attribute[:attr_type] == 'Normal'
          case attribute[:sql_type]
          when :string
            # 是否是 CarrierWave Uploader
            if resource.respond_to?("remote_#{attribute[:attr_name]}_url")
              f.file_field attribute[:attr_name]
            else
              f.text_field attribute[:attr_name]
            end
          when :text
            if resource.respond_to?("remote_#{attribute[:attr_name]}_url")
              f.file_field attribute[:attr_name]
            else
              f.text_area attribute[:attr_name]
            end
          when :integer
            f.number_field attribute[:attr_name]
          when :float
            f.number_field attribute[:attr_name]
          when :datetime
            f.text_field attribute[:attr_name], class: 'datepicker'
          else
            f.text_field attribute[:attr_name]
          end
        else
          case attribute[:attr_type]
          when 'HasOneReflection'
            "---不支持编辑HasOneReflection---"
          when 'HasManyReflection'
            "---不支持编辑HasManyReflection---"
          when 'HasAndBelongsToManyReflection'
            "---不支持编辑HasAndBelongsToManyReflection---"
          when 'BelongsToReflection'
            column_field = attribute[:attr_name].foreign_key
            model = attribute[:attr_name].classify.constantize
            f.select column_field, options_for_select(model.all.map{|m| [m.__to_s, m.id]}, resource.send(attribute[:attr_name])), {}, allow_nil: false, class: 'ui dropdown'
          else
            "---#{attribute}---"
          end
        end
      end
    end

    # 用于在 form_for 中生成相应的 url
    def delegate_form_url(resource)
      if resource.new_record?
        delegate_resources_path
      else
        delegate_resource_path(resource)
      end
    end

    # 用于在 form_for 中生成相应的 form method
    def delegate_form_method(resource)
      if resource.new_record?
        :post
      else
        :patch
      end
    end

    # list url
    def delegate_resources_path(options = {})
      self.send("admin_delegate_#{@__resource_name.pluralize}_path", options)
    end

    # resource url
    def delegate_resource_path(options = {})
      self.send("admin_delegate_#{@__resource_name}_path", @_resource, options)
    end

    # edit resource url
    def delegate_edit_resource_path(options = {})
      self.send("edit_admin_delegate_#{@__resource_name}_path", @_resource, options)
    end

    # action resource url
    def delegate_action_resource_path(action, options = {})
      self.send("#{action}_admin_delegate_#{@__resource_name}_path", @_resource, options)
    end
  end
end
