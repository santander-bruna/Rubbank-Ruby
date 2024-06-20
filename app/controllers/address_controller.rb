class AddressController < ApplicationController

    def index
        @addresses = Address.all
        render json: @addresses
    end

    def show
        @address = Address.find(params[:id])
        if @address
            render json: @address, status: :ok
        else
            render json: { error: 'Address not found' }, status: :not_found
        end
    end

    def create
        @address = Address.new(address_params)
        if @address.save
            render json: @address, status: :created
        else
            render json: @address.errors, status: :unprocessable_entity
        end
    end

    def update
        @address = Address.find(params[:id])
        success = false
        if address_params[:user_id] || address_params[:id]
            success = false
        else
            params.require(:address).permit(:street, :city, :state, :zip_code, :neighborhood).each do |key, value|
                @address.update_column(key, value)
                success = true
            end
        end
        if success
            render json: @address, status: :ok
        else
            render json: { error: 'Failed to update address' }, status: :unprocessable_entity
        end
    end

    def destroy
        @address = Address.find(params[:id])
        @user = User.find(@address.user_id)
        if @user.destroy
            render json: { message: 'Address deleted successfully' }, status: :ok
        else
            render json: { error: 'Failed to delete address' }, status: :unprocessable_entity
        end
    end

    private

    def address_params
      params.require(:address).permit(:street, :city, :state, :zip_code, :neighborhood, :user_id)
    end
end
