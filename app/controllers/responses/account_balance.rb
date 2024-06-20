class AccountBalance
    attr_accessor :id, :account_number, :agency, :name, :balance
  
    def initialize(id, account_number, agency, name, balance)
      @id = id
      @account_number = account_number
      @agency = agency
      @name = name
      @balance = balance
    end
  
    def as_json(options = {})
      {
        id: id,
        accountNumber: account_number,
        agency: agency,
        name: name,
        balance: balance,
      }
    end
end