class CreateFuzzies < ActiveRecord::Migration[5.2]
  def change
    create_table :fuzzies do |t|
      t.string :fuzzy_text
      t.string :payee_name

      t.timestamps
    end
  end
end
