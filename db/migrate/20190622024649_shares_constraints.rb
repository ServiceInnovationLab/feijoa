class SharesConstraints < ActiveRecord::Migration[5.2]
  def change
    add_index :shares,
      [:birth_record_id, :user_id, :recipient_id, :recipient_type],
      unique: true,
      name: 'index_unique_shares'
  end
end
