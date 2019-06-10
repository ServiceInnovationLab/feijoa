class CreateJoinTableUserBirthRecord < ActiveRecord::Migration[5.2]
  def change
    create_join_table :users, :birth_records do |t|
      t.index [:user_id, :birth_record_id]
      t.index [:birth_record_id, :user_id]
    end
  end
end
