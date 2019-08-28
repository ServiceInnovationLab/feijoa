class AddRevokedByToShare < ActiveRecord::Migration[5.2]
  def change
    change_table :shares do |t|
      t.references :revoked_by, polymorphic: true
      t.timestamp :revoked_at
    end

    add_index :shares, :revoked_at
  end
end
