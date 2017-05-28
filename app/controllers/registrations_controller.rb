class RegistrationsController < ApplicationController
  skip_before_action :authenticate!

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = t('registrations.user.success')
      redirect_to :root
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :password)
  end
end
