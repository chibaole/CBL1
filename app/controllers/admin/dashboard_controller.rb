module Admin
  class DashboardController < AdminController
    def index
      @unshipping_orders_count = PromotionOrder.confirmed.count
    end
  end
end
