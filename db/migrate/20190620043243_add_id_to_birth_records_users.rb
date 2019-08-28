class AddIdToBirthRecordsUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :birth_records_users, :id, :primary_key
  end
end
