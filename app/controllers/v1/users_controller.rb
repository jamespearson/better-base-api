class V1::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :get_user, only: [:show, :update, :delete]

  def index
    @users = UserPolicy::Scope.new(current_user, User.all).resolve
    authorize @users
    render json: UserSerializer.new(@users).serializable_hash
  end

  def show
    authorize @user
    render json: UserSerializer.new(@user).serializable_hash
  end

  def update
    authorize @user
    @user.update!(user_update_params)
    render json: UserSerializer.new(@user).serializable_hash
  end

  def delete
  end

  private

  def get_user
    @user ||= UserPolicy::Scope.new(current_user, User.where(id: params[:id]).limit(1)).resolve.first
  end

  def user_update_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
