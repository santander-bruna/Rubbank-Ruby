require "rails_helper"
require "./app/controllers/accounts_controller"
require "faker"
require 'cpf_faker'


RSpec.describe "AccountsController", type: :controller do
  it "index" do
    expect(Account.all).to match_array(Account.new(id: 35)).or match_array([])
  end

  it "show" do
    @id = rand(100)
    account = Account.find_by(id: @id)
    success = false
    if account
      success = true
      expect(success).to be_truthy
    else
      expect(success).to be_falsey
    end
  end

  it "getByAccountNumber" do
    num = (rand * 10).floor + 1
    account_number = "123" + (num * 2).to_s + (num * 3).to_s
    success = false
    account = Account.find_by(num_account: account_number)
    if !account
      expect(success).to be_falsey
    else
      expect(success).to be_truthy
    end
  end

  it "getByUserId" do 
    @id = rand(100)
    account = Account.find_by(user_id: @id)
    success = false
    if account
      success = true
      expect(success).to be_truthy
    else
      expect(success).to be_falsey
    end
  end 

  it "update" do
    @id = rand(100)
    account_params = { password: "2010" }
    success = false
    account = Account.find_by(id: @id)
    if !account
      expect(success).to be_falsey
    else
        account_params.require(:account).permit(:password, :status).each do |key, value|
        account.update_column(key, value)
        success = true
      end
      expect(success).to be_truthy
    end
  end

  it "destroy" do
    @id = rand(100)
    success = false
    account = Account.find_by(id: @id)
    if !account
      expect(success).to be_falsey
    else
      expect(account.destroy).to be_truthy
    end
  end

  it "getBalance" do
    @id = rand(100)
    success = false
    account = Account.find_by(id: @id)
    if !account
        expect(success).to be_falsey
    else
        balance = account.balance
        expect(balance).to be_a(numeric)
    end
  end
end