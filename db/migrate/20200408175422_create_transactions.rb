class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.date :date
      t.decimal :amount
      t.integer :payee_id
      t.integer :account_id
      t.string :guid

      t.timestamps
    end
  end
end
