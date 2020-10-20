class Payee < ApplicationRecord
  
  #  t.string :name   // maps to <NAME> ofx
  #  t.string :friendly_name
  
  has_many :transactions
end
