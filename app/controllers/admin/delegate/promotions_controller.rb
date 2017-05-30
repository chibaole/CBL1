module Admin
  module Delegate
    class PromotionsController < BaseController
      skip_before_action :set_resource, only: SET_RESOURCE_FILTER
      before_action :set_resource, only: SET_RESOURCE_FILTER

      def edit

      end

      private
      def resource_params
        params.require(:promotion).permit(:name, :started_at, :expired_at, :state, :message_template, product_ids: [])
      end
    end
  end
end
