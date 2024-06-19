class AccountService
    def generateAccountNumber 
        num = (rand * 10).floor + 1
        return "123" + (num * 2).to_s + (num * 3).to_s
    end

    def generateAccount
        service = AccountService.new
        num_account = service.generateAccountNumber
    
        # Validate the account number
        while Account.exists?(num_account: num_account)
            num_account = service.generateAccountNumber
        end
    
        return num_account;
    end
end