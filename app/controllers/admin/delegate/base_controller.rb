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
          skip_before_action :set_resource#, only: SET_RESOURCE_FILTER
          before_action :set_resource, only: actions
        end
      end

      def index
        @resources = @resource_model.page(page).per(count)
        @attributes = Kaminari.paginate_array(@resource_attributes).page(attr_page).per(attr_count)
      end

      def new
        @resource = @resource_model.new
      end

      def create
        @resource = @resource_model.new(resource_params)
        if @resource.save
          redirect_to send("admin_delegate_#{@resource_name}_path", @resource)
        else
          render :new
        end
      end

      def edit

      end

      def update
        if @resource.update(resource_params)
          redirect_to send("admin_delegate_#{@resource_name}_path", @resource)
        else
          render :edit
        end
      end

      def show
      end

      def destroy
        @resource.destroy
        redirect_to send("admin_delegate_#{@resource_name.pluralize}_path")
      end

      #-------------
      # Utils and Helper Methods
      #-------------
      #~~~~~~~~~~~~~
      
      protected

      def set_resource
        if @resource_attributes.include?('guid')
          @resource = @resource_model.find_by_guid(params[:id])
        end

        if @resource.nil?
          @resource = @resource_model.find_by_id(params[:id])
        end
      end

      def set_resource_model
        matched = request.url.match(/admin\/delegate\/(.*)/)
        resource_class = matched[1].split('/')[0]
        resource_class = resource_class.split('?')[0].classify
        @resource_model = resource_class.constantize
        @resource_name = resource_class.singularize.underscore
        @resource_attributes = @resource_model.attribute_names - ['created_at', 'updated_at']

        uneditable_attrs = ['id', 'guid', 'created_at', 'updated_at']

        attributes = @resource_model.u_attrs_with_sql_type.reject{|k, v| k.in?(uneditable_attrs)}

        @resource_editable_attributes = attributes.map {|k, v| k}
        @permitable_params = attributes.map{|k, v|
          if v[:attr_type] == 'Normal'
            k.to_sym
          elsif v[:attr_type] == 'BelongsToReflection'
            k.foreign_key.to_sym
          end
        }
      end

      def attr_page
        @attr_page ||= params[:attr_page].try(:to_i) || 1
      end

      def attr_count
        @attr_count ||= params[:attr_count].try(:to_i) || 7
      end

      def resource_params
        params.require(@resource_name).permit(@permitable_params)
      end
    end
  end
end
