class PromotionOrdersController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_order, only: [:show, :edit, :update, :confirm, :do_confirm, :success]
  before_action :set_active_code, only: [:new, :create, :edit]

  def new
    if @promotion_code.exchanged? && @promotion_code.promotion_order.present?
      redirect_to promotion_order_path(@promotion_code.promotion_order)
      return
    end

    @promotion = @promotion_code.promotion
    @promotion_order = PromotionOrder.new
  end

  def create
    if @promotion_code.exchanged? && @promotion_code.promotion_order.present?
      redirect_to promotion_order_path(@promotion_code.promotion_order)
      return
    end

    @order = PromotionOrder.new(order_params)
    @order.promotion_code = @promotion_code
    @order.state = 0

    respond_to do |format|
      if @promotion_code.can_exchange?
        if @order.save
          # 前往确认页面
          @promotion_code.exchanged!
          format.html { redirect_to confirm_promotion_order_path(@order) }
        else
          # 返回原页面
          format.html {
            flash[:error] = @order.errors.full_messages
            render :new
          }
        end
      else
        format.html {
          # 返回到兑换页面
          flash[:error] = '已经无法兑换'
          redirect_to code_promos_path
        }
      end
    end
  end

  def edit
    @promotion = @promotion_code.promotion
  end

  def update
    unless @promotion_order.init?
      # NOTE 状态错误，已经无法修改
      flash[:error] = @promotion_order.errors.full_messages
      render :edit
      return
    end

    if @promotion_order.update(order_params)
      redirect_to confirm_promotion_order_path(@promotion_order)
    else
      flash[:error] = @promotion_order.errors.full_messages
      render :edit
    end
  end

  def confirm

  end

  def do_confirm
    unless @promotion_order.init?
      render :confirm
      return
    end

    if @promotion_order.confirmed!
      # TODO 发送短信
      redirect_to success_promotion_order_path(@promotion_order)
    end
  end

  def show

  end

  def success

  end

  private
  def set_order
    @promotion_order = PromotionOrder.find_by_guid(params[:id])
  end

  def order_params
    params.require(:promotion_order).permit(:customer_name, :customer_telephone, :address, :reserved_delivery_date, :province, :city, :distinct)
  end
end
