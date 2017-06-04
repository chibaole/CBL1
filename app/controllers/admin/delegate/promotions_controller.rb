module Admin
  module Delegate
    class PromotionsController < BaseController
      def edit

      end

      private
      def resource_params
        params.require(:promotion).permit(:name, :started_at, :expired_at, :state, :message_template, :start_delivery_at, :end_delivery_at, product_ids: [])
      end
    end
  end
end
