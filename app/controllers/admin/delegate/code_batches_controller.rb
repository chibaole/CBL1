module Admin
  module Delegate
    class CodeBatchesController < BaseController
      # skip_before_action :set_resource, only: SET_RESOURCE_FILTER
      # before_action :set_resource, only: SET_RESOURCE_FILTER + [:generate_codes, :codes]
      append_set_resource_before_action actions: [:generate_codes, :codes]

      def codes

      end

      def generate_codes
        @resource.generate_codes
        redirect_to codes_admin_delegate_code_batch_path(@resource)
      end
    end
  end
end
