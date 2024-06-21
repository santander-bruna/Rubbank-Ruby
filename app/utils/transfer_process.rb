module TransferProcess
    module_function
  
    def process_tranfers(beneficiary, payer, transfer)
        @payerAccount = Account.getByUserId(payer.id)
        @beneficiaryAccount = Account.getByUserId(beneficiary.id)

        payer_balance =  @payerAccount.balance - transfer.amount
        beneficiary_balance = @beneficiaryAccount.balance + transfer.amount
        
        @payerAccount.update_column(:balance, payer_balance)
        @beneficiaryAccount.update_column(:balance, beneficiary_balance)

        @transfer = Transfer.new(
          payer_id: payer.id,
          beneficiary_id: beneficiary.id,
          amount: transfer.amount,
          description: transfer.description,
          date: Date.today
        )

        @transfer.save
    end
end