class AddDiscardedToBirthRecordsUsers < ActiveRecord::Migration[5.2]
  def change
    change_table :birth_records_users do |t|
      t.timestamp :discarded_at
    end

    add_index :birth_records_users, :discarded_at
  end
end
