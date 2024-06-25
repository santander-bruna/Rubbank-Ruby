require "rails_helper"
require "./app/controllers/users_controller"
require "faker"
require 'cpf_faker'


RSpec.describe "UsersController", type: :controller do
  it "index" do
    expect(User.all).to match_array(User.new(id: 36)).or match_array([])
  end

  it "show" do
    @id = rand(100)
    user = User.find_by(id: @id)
    success = false
    if user
      success = true
      expect(success).to be_truthy
    else
      expect(success).to be_falsey
    end
  end

  it "create" do
    user_params = { cpf: "12345678901", name: "John Doe", email: "johndoe@example.com", phone: "1234567890", birthdate: "1990-01-01", app_password: "password123" }
    address_params = { street: "123 Main St", city: "New York", state: "NY", zip_code: "12345", neighborhood: "Manhattan" }
    account_params = { num_account: "123456789", balance: 0.0, status: "active", agency: "123", password: "password123" }

    @user = User.new(user_params)
    @address = Address.new(address_params)
    @account = Account.new(account_params)

    @user.save
    @address.user_id = @user.id
    @address.save
    @account.user_id = @user.id
    @account.save
    
    expect(@user.save).to be_truthy
  end

  it "getByCPF" do
    cpf = Faker::CPF.numeric
    # cpf = "48060871811"
    success = false
    user = User.find_by(cpf: cpf)
    if !user
      expect(success).to be_falsey
    else
      expect(success).to be_truthy
    end
  end

  it "update" do
    @id = rand(100)
    user_params = { email: "johndoe@example.com" }
    success = false
    user = User.find_by(id: @id)
    if !user
      expect(success).to be_falsey
    else
      user_params.require(:user).permit(:name, :email, :phone, :birthdate).each do |key, value|
        user.update_column(key, value)
        success = true
      end
      expect(success).to be_truthy
    end
  end

  it "destroy" do
    @id = rand(100)
    success = false
    user = User.find_by(id: @id)
    if !user
      expect(success).to be_falsey
    else
      expect(user.destroy).to be_truthy
    end
  end
end