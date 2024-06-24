class TransferService
  def transfer(beneficiaryAccount, transfer)
    if beneficiaryAccount.status != "active"
      return { error: "Conta do beneficiário está inativa ou bloqueada." }, :unauthorized
    end
    @payerAccount = Account.getByUserId(transfer.payer_id);
    if beneficiaryAccount.id == @payerAccount.id
      return { error: "Transferência não pode ser realizada para o próprio usuário." }, :unauthorized
    end
    if @payerAccount.status != "active"
      return { error: "Conta do pagador está inativa ou bloqueada." }, :unauthorized
    end
    if @payerAccount && beneficiaryAccount && beneficiaryAccount.balance != nil && @payerAccount.balance != nil
      if transfer.amount <= 0 || transfer.amount.nil?
        return { error: "Valor da transferência inválido." }, :bad_request
      else
        if transfer.amount > @payerAccount.balance
          return { error: "Saldo insuficiente." }, :unprocessable_entity
        else
          @beneficiary = User.find(beneficiaryAccount.user_id)
          @payer = User.find(@payerAccount.user_id)
          return TransferProcess.process_tranfers(@beneficiary, @payer, transfer), :created
        end
      end
    end
  end
end
