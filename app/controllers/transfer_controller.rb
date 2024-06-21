require_relative "../../app/services/transfer_service"
require_relative "../../app/services/jwt_service"
require_relative '../../app/controllers/requests/transfer_request'

class TransferController < ApplicationController
    before_action :authenticate_request, only: [:create, :show, :index, :update]
    def index 
        @transfers = Transfer.all
        render json: @transfers
    end

    def show
        @transfer = Transfer.find(params[:id])
        render json: @transfer
    end

    def create
        service = TransferService.new
        transfer = TransferRequest.new(transfer_params[:id], transfer_params[:password],
        transfer_params[:amount], transfer_params[:beneficiary_id], transfer_params[:payer_id],
        transfer_params[:description], transfer_params[:date], transfer_params[:cpf], transfer_params[:account]);
        @user = User.find(transfer_params[:payer_id])
        if @user.nil?
            render json: { error: "User not found" }, status: :not_found
        else
            @account = Account.getByUserId(@user.id)
            if BCrypt::Password.new(@account.password) == transfer_params[:password]
                transfer.payer_id = @user.id
                if transfer.cpf
                    @user = User.getByCpf(transfer.cpf);
                    @accountBeneficary = Account.getByUserId(@user.id);
                    result, status = service.transfer(@accountBeneficary, transfer)
                    render json: result, status: status
                elsif transfer.account
                    @accountBeneficary = Account.getByNumber(transfer_params[:account]);
                    result, status = service.transfer(@accountBeneficary, transfer)
                    render json: result, status: status
                end
            else
                render json: { error: "Invalid password" }, status: :unauthorized
            end
        end
    end

    def update
        @transfer = Transfer.find(params[:id])
        if @transfer.update(transfer_params)
          render json: @transfer, status: :ok
        else
          render json: @transfer.errors, status: :unprocessable_entity
        end
    end

    def transfer_params
        params.require(:transfer).permit(:password, :amount, :beneficiary_id, :payer_id, :description, :date, :cpf, :account)
    end

    private
    def authenticate_request
        jwt_service = JsonWebToken.new
        token = jwt_service.decode(request)
        if token
            @current_user = User.find(token[0]['user_id'])
            return @current_user.id == params[:payer_id]
        else
            render json:  { error: 'Unauthorized' }, status: :unauthorized
        end
    end
end
