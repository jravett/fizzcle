class AddPayeeLastTag < ActiveRecord::Migration[5.2]
  def change
	add_column :payees, :last_tag, :string
  end
end
