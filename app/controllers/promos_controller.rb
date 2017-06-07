class PromosController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_active_code, only: [:verify, :exchange]

  # 输入核销码界面
  # GET /promos/code
  def code

  end

  # POST /promos/verify
  def verify
    # 可用的核销码不存在
    if @promotion_code.nil?
      render :code
      return
    end

    if @promotion_code.exchanged?
      # 1. 已经领取
      redirect_to promotion_order_path(@promotion_code.promotion_order)
    else
      # 2. 未领取
      if @promotion_code.can_exchange?
        # 可以领取
        redirect_to new_promotion_order_path(_c: @promotion_code.code)
      else
        #
        render :code
      end
    end
  end

  # GET /promos/confirm_info/:id
  def confirm_info
  end

  # PUT /promos/confirm/:id/
  def confirm
  end

  # GET /promos/success/:id/
  def success
  end

  # GET /promos/:id
  def detail
  end

  private
end
