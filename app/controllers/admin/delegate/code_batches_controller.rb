module Admin
  module Delegate
    class CodeBatchesController < BaseController
      append_set_resource_before_action actions: [:generate_codes, :codes]

      def codes
        @promotion_codes = @_resource.promotion_codes.page(page).per(count)
      end

      def generate_codes
        @_resource.generate_codes
        redirect_to codes_admin_delegate_code_batch_path(@_resource)
      end
    end
  end
end
