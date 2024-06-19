json.user do
    json.extract! @user, :id, :cpf, :name, :email, :phone, :birthdate, :app_password
    json.address do
      json.extract! @address, :street, :city, :state, :zip_code, :neighborhood
    end
    json.account do
      json.extract! @account, :num_account, :balance, :status, :agency, :password
    end
end