class Admin::UsersController < ApplicationController

  before_action :check_admin_only

  def index 
    @users = User.all.order("firstname").page(params[:page]).per(3)
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    UserMailer.deleted_user(@user).deliver
    redirect_to admin_users_path
  end

  private

  def check_admin_only
    p current_user
    if !current_user || !current_user.admin
      redirect_to movies_path
    end
  end

end