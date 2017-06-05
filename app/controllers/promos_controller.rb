class PromosController < ApplicationController
  skip_before_action :authenticate_user!

  # 输入核销码界面
  # GET /promos/code
  def code

  end

  # POST /promos/submit_code
  def submit_code
    # 1. 已经领取
    # 2. 验证通过，输入信息
  end

  # GET /promos/info
  def info

  end

  # POST /promos/submit_info
  def submit_info
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
  def show

  end
end
