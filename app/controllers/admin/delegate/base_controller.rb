module Admin
  module Delegate
    class BaseController < AdminController
      helper_method :attr_page, :attr_count
      # @resource_model: ShopItem
      # @resource_name: shop_item
      # @resource: <ShopItem: 231231231>

      SET_RESOURCE_FILTER = [:show, :edit, :update, :destroy]

      before_action :set_resource_model
      before_action :set_resource, only: SET_RESOURCE_FILTER

      class << self
        def append_set_resource_before_action(actions: [])
          actions += SET_RESOURCE_FILTER
          skip_before_action :set_resource
          before_action :set_resource, only: actions
        end
      end

      def index
        p = params.dup.to_unsafe_h
        allowed_search_keys = @__resource_attriutes.select{|a| a[:column_name]}.map{|a| a[:column_name].to_s }
        p.select!{|k, v| k.in?(allowed_search_keys) }

        @_resources = @__resource_model.where(p).page(page).per(count)
        @_attributes = Kaminari.paginate_array(@__resource_attriutes).page(attr_page).per(attr_count)
      end

      def new
        @_resource = @__resource_model.new
      end

      def create
        @_resource = @__resource_model.new(resource_params)
        if @_resource.save
          redirect_to send("admin_delegate_#{@__resource_name}_path", @_resource)
        else
          flash[:error] = @_resource.errors.full_messages
          render :new
        end
      end

      def edit

      end

      def search
        @_q = params[:q]
        @_resources = @__resource_model.__search(params[:q], fields: (params[:fields] || [])).page(page).per(count)
        # @_resources = @__resource_model.where(p).page(page).per(count)
        @_attributes = Kaminari.paginate_array(@__resource_attriutes).page(attr_page).per(attr_count)
      end

      def update
        if @_resource.update(resource_params)
          redirect_to send("admin_delegate_#{@__resource_name}_path", @_resource)
        else
          flash[:error] = @_resource.errors.full_messages
          render :edit
        end
      end

      def show
      end

      def destroy
        @_resource.destroy
        redirect_to send("admin_delegate_#{@__resource_name.pluralize}_path")
      end

      #-------------
      # Utils and Helper Methods
      #-------------
      #~~~~~~~~~~~~~

      protected

      def set_resource
        if @__resource_model.__attrs_with_sql_type.keys.include?('guid')
          @_resource = @__resource_model.find_by_guid(params[:id])
        end

        if @_resource.nil?
          @_resource = @__resource_model.find_by_id(params[:id])
        end
      end

      def set_resource_model
        matched = request.url.match(/admin\/delegate\/(.*)/)
        resource_class = matched[1].split('/')[0]
        resource_class = resource_class.split('?')[0].classify
        uneditable_attrs = ['id', 'guid', 'created_at', 'updated_at']

        # Class
        @__resource_model = resource_class.constantize
        # 对象
        @__resource_name = resource_class.singularize.underscore
        # 所有属性
        @__resource_attriutes = @__resource_model.__attrs_with_sql_type.values
        # 所有可编辑属性
        @__editable_attributes = @__resource_attriutes.reject{|attr| attr[:attr_name].in?(uneditable_attrs)}
        # Permit params
        @__permit_params = @__editable_attributes.map do |attr|
          if attr[:attr_type] == 'Normal'
            attr[:attr_name].to_sym
          elsif attr[:attr_type] == 'BelongsToReflection'
            attr[:column_name].to_sym
          end
        end
      end

      def attr_page
        @_attr_page ||= params[:attr_page].try(:to_i) || 1
      end

      def attr_count
        @_attr_count ||= params[:attr_count].try(:to_i) || 5
      end

      def resource_params
        params.require(@__resource_name).permit(@__permit_params)
      end
    end
  end
end
