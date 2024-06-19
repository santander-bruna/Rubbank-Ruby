class Account < ApplicationRecord
  belongs_to :user

  def self.getByUserId(id)
    Account.find_by(user_id: id)
  end
end
