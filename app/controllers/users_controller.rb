require_relative '../../app/services/account_service'
require_relative '../../app/services/jwt_service'
require "bcrypt"

class UsersController < ApplicationController
  before_action :authenticate_user, only: [:index, :show, :update, :destroy]

  # Return all the users
  def index
    @users = User.all
    render json: @users
  end

  # Return a single user based on the provided id
  def show
    @user = User.find(params[:id])
    if @user
      render json: @user, status: :ok
    else
      render json: @user.errors, status: :not_found
    end
  end

  # Return a single user based on the provided cpf
  def getByCpf
    @user = User.find_by(params[:cpf])
    if @user
      render json: @user, status: :ok
    else
      render json: @user.errors, status: :not_found
    end
  end

  # Create a new user
  def create
    @user = User.new(user_params)
    @address = Address.new(address_params)
    @account = Account.new(account_params)

    account_service = AccountService.new
    user = User.getByCpf(@user.cpf)
    if user
      account = Account.getByUserId(user.id)
      if account != nil && account.status == "inactive" || account.status == "blocked"
        return render json: {error: 'User is inactive or blocked'}, status: :conflic
      end
    else
      @account.agency = "123"
      @account.num_account = account_service.generateAccount
      @account.status = "active"
      @account.balance = 0.00

      @account.password =  BCrypt::Password.create(account_params[:password]).to_s
      @user.app_password =  BCrypt::Password.create(user_params[:app_password]).to_s

      if @user.save 
        @address.user_id = @user.id
        @account.user_id = @user.id
        @address.save
        @account.save
        return render json: @user, status: :created
      else
        return render json: @user.errors, status: :unprocessable_entity
      end
    end
  end

  def update
    @user = User.find(params[:id])
  
    if @user.id.nil? || @user.cpf.nil? || @user.name.nil? || @user.birthdate.nil?
      success = false
    else 
      user = User.find(params[:id])
      if params[:app_password].present?
        password = user_params[:app_password]
        if BCrypt::Password.new(user.app_password) == password
          success = false
        else
          user.update_column(:app_password, password)
          success = true
        end
      end
      params.require(:user).permit(:name, :email, :phone, :birthdate).each do |key, value|
        user.update_column(key, value)
        success = true
      end
  
      if success
        render json: { message: 'User updated successfully' }, status: :ok
      else
        render json: { error: 'Error to update user' }, status: :unprocessable_entity
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      render json: { message: 'User deleted successfully' }, status: :ok
    else
      render json: { error: 'Error to delete user' }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  # Set the user param alloweds
  def user_params
    params.require(:user).permit(:cpf, :name, :email, :phone, :birthdate, :app_password)
  end

  private

  def address_params
    params.require(:address).permit(:street, :city, :state, :zip_code, :neighborhood)
  end

  private

  def account_params
    params.require(:account).permit(:num_account, :balance, :status, :user_id, :agency, :password)
  end


  private
  def authenticate_user
    jwt_service = JsonWebToken.new
    token = jwt_service.decode(request)
    if token
      @current_user = User.find(token[0]['user_id'])
    else
      render json:  { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end