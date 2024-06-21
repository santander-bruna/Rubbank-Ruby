class User < ApplicationRecord
  has_one :address
  has_one :account

  validates :cpf, presence: true, uniqueness: true
  validates :app_password, presence: true, on: :create

  before_save :save_address_and_account
  before_destroy :destroy_address_and_account
  def self.getByCpf(cpf)
    User.find_by(cpf: cpf)
  end

  def authenticate(password)
    BCrypt::Password.new(self.app_password) == password
  end

  private 

  def save_address_and_account
    self.address.save if self.address.present?
    self.account.sabe if self.account.present?
  end 

  def destroy_address_and_account
    self.address.destroy if self.address.present?
    self.account.destroy if self.account.present?
  end 
end
