class Address < ApplicationRecord
  belongs_to :user

  def self.getByUserId(id)
    Address.find_by(user_id:, id)
  end
end
