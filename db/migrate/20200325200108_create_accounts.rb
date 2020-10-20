class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
   
	  t.string :name
	  t.integer :fi_id
	  t.date :last_import_date

      t.timestamps
    end
  end
end
