class Account < ApplicationRecord
  belongs_to :user

  def self.getByUserId(id)
    Account.find_by(user_id: id)
  end

  def self.findByAccountNumber(number)
    Account.find_by(num_account: number)
  end
end
