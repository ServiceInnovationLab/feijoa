class AddLastAccessedAtColumnToShares < ActiveRecord::Migration[5.2]
  def change
    change_table :shares do |t|
      t.timestamp :last_accessed_at
    end
  end
end
