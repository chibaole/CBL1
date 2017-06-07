class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  helper_method :warden, :signed_in?, :current_user

  def signed_in?
    !current_user.nil?
  end

  def current_user
    warden.user
  end

  def warden
    request.env['warden']
  end

  def authenticate_user!
    warden.authenticate!
  end

  def page
    @page = params[:page] || 1
  end

  def count
    @count = params[:count] || 20
  end
  
  # 使用参数 _c 设置核销码 @code
  def set_active_code
    @promotion_code = PromotionCode.active.where(code: params[:_c]).first
    # NTOE 跳转
  end
end
