class AddAccountAttributes < ActiveRecord::Migration[5.2]
  def change
	add_column :accounts, :ofx_ORG, :string
	add_column :accounts, :ofx_FI, :string
	add_column :accounts, :ofx_ACCTID, :string
	add_column :accounts, :balance, :decimal, :precision=>8, :scale=>2
  end
end
