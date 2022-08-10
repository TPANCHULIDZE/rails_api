class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: %i[show destroy update]
  before_action :check_owner, only: %i[update destroy]
  
  def show
    render json: user_serializer
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: user_serializer,  status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user&.authenticate(params[:user][:old_password]) && @user.update(user_params)
      render json: user_serializer, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    head 204
  end

  private 

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def check_owner
    head :forbidden unless @user.id == current_user&.id
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_serializer
    options = { include: [:products] }
    UserSerializer.new(@user, options).serializable_hash.to_json
  end
end
