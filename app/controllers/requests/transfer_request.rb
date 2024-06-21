class TransferRequest
    attr_accessor :id, :password, :amount, :beneficiary_id, :payer_id, :description, :date, :cpf, :account
  
    def initialize(id, password, amount, beneficiary_id, payer_id, description, date, cpf, account)
      @id = id
      @password = password
      @amount = amount
      @beneficiary_id = beneficiary_id
      @payer_id = payer_id
      @description = description
      @date = date
      @cpf = cpf
      @account = account
    end
end