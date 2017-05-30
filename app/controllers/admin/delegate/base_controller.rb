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
          flash[:error] = @resource.errors.full_messages
          render :new
        end
      end

      def edit

      end

      def update
        if @resource.update(resource_params)
          redirect_to send("admin_delegate_#{@resource_name}_path", @resource)
        else
          flash[:error] = @resource.errors.full_messages
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
          puts 'find_by_guid'
          @resource = @resource_model.find_by_guid(params[:id])
        end

        if @resource.nil?
          puts 'find_by_id'
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
        @resource_editable_attributes = @resource_model.all_attributes.map{|a| a[:attr_name]} - ['id', 'guid']
      end

      def attr_page
        @attr_page ||= params[:attr_page].try(:to_i) || 1
      end

      def attr_count
        @attr_count ||= params[:attr_count].try(:to_i) || 7
      end

      def resource_params
        params.require(@resource_name).permit(@resource_editable_attributes.map(&:to_sym))
      end
    end
  end
end
