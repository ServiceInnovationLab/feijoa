class CreateImmunisationRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :immunisation_records do |t|
      t.string :full_name, null: false
      t.date :date_of_birth, null: false
      t.jsonb :data

      t.timestamps
    end
  end
end
