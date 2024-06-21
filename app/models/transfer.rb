class Transfer < ApplicationRecord
    belongs_to :beneficiary, class_name: "Account", optional: true
    belongs_to :payer, class_name: "Account", optional: true
end
