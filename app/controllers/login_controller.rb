require_relative '../../app/services/jwt_service'

class LoginController < ApplicationController
    def login
        jwt_service = JsonWebToken.new
        @user = User.getByCpf(params[:cpf])
        if @user && @user.authenticate(params[:password])
            @account = Account.getByUserId(@user.id)
            if @account && @account.status != 'active'
                render json: { error: 'Account is not active' }, status: :unauthorized
            else
                token = jwt_service.encode({ user_id: @user.id })
                render json: { token: token }, status: :ok
            end
        else 
            render json: { error: 'Invalid credentials' }, status: :unauthorized
        end
    end
end
