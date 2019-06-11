class CreateBirthRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :birth_records do |t|
      t.string :first_and_middle_names,              null: false, default: ""
      t.string :family_name,                         null: false, default: ""
      t.date :date_of_birth
      t.string :place_of_birth,                      null: false, default: ""
      t.string :sex,                                  null: false, default: ""
      t.string :parent_first_and_middle_names,       null: false, default: ""
      t.string :parent_family_name,                  null: false, default: ""
      t.string :other_parent_first_and_middle_names, null: false, default: ""
      t.string :other_parent_family_name,            null: false, default: ""

      t.timestamps null: false
    end

    add_index :birth_records, :family_name
    add_index :birth_records, :first_and_middle_names
  end
end
