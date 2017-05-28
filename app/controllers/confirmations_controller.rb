class ConfirmationsController < ApplicationController
  skip_before_action :authenticate!
  before_action :redirect_if_token_empty!

  def show
    @user = User.find_by_confirmation_token(params[:token])

    if @user.nil?
      flash[:alert] = t('confirmation.user.errors')
      redirect_to :root and return
    else
      flash[:notice] = t('confirmation.users.confirmed')
      @user.confirm!
      warden.set_user(@user)
      redirect_to user_path(@user) and return
    end
  end

  protected

  def redirect_if_token_empty!
    unless params.has_key?(:token)
      flash[:alert] = t('confirmation.token.empty')
      redirect_to :root and return
    end
  end
end
