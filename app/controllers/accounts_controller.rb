require "bcrypt"
require_relative '../../app/services/account_service'
require_relative '../../app/controllers/responses/account_balance'

class AccountsController < ApplicationController
    # Return all the accounts
    def index
        @accounts = Account.all

        filter = params[:balance]

        if filter
            @accounts = @accounts.where("balance >=?", filter.to_i)
        end
        accounts_hashes = @accounts.map do |account|
            account.attributes.except("password")
        end
        filteredAccounts = OutputFormatter.exclude_array_keys(accounts_hashes,
        ["balance", "created_at", "updated_at", "password"])
        render json: filteredAccounts
    end

    # Return a single account based on the provided id
    def show
        # vai precisar de token
        @accounts = Account.find(params[:id])
        if @accounts
            render json: @accounts, status: :ok
        else
            render json: @accounts.errors, status: :not_found
        end
    end

    # Get Account by account number
    def getByAccountNumber
        @account = Account.findByAccountNumber(params[:account])
        if @account
            render json: @account, status: :ok
        else
            render json: @account.errors, status: :not_found
        end
    end

    # Return a account by user id
    def getByUserId
        @account = Account.getByUserId(params[:user])
        if @account
            render json: @account, status: :ok
        else
            render json: @account.errors, status: :not_found
        end
    end

    # Create a new account
    def create
        account_service = AccountService.new
        @account = Account.new(account_params)
        @account.num_account = account_service.generate_account_number
        @account.status = "active"
        @account.balance = 0.00
        @account.password =  BCrypt::Password.create(account_params[:password]).to_s

        if @account.save
            render json: @account, status: :created
        else
            render json: @account.errors, status: :unprocessable_entity
        end
    end

    # Update an existing account
    def update
        @account = Account.find(params[:id])
        @updateAccount = Account.new(account_params)
        if @account && @updateAccount.password.present?
            if BCrypt::Password.new(@account.password) == params[:password]
                render json: @account.errors, status: :method_not_allowed
            else
                @updateAccount.password = BCrypt::Password.create(account_params[:password]).to_s
                @account.update_column(:password, @updateAccount.password)
                render json: @account, status: :ok
            end
        else
            render json: @account.errors, status: :method_not_allowed
        end
    end

    # Delete an existing account
    def destroy
        @account = Account.find(params[:id])
        @user = User.find(@account.user_id)
        if @user.destroy
            render json: { message: 'Account deleted successfully' }, status: :ok
        else
            render json: { error: 'Error to delete account' }, status: :unprocessable_entity
        end
    end

    # Get account balance by account id
    def getBalance
        @account = Account.find(params[:id])
        @user = User.find(@account.user_id)
        if @account && @user
            account_balance = AccountBalance.new(@account.id, @account.num_account,
            @account.agency, @user.name, @account.balance)
            render json: {account: account_balance.as_json}, status: :ok
        else
            render json: @account.errors, status: :not_found
        end
    end

    def account_params
        params.require(:account).permit(:num_account, :balance, :status, :user_id, :agency, :password)
    end
end
