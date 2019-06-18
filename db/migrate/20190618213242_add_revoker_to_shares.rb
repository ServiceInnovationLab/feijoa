class AddRevokerToShares < ActiveRecord::Migration[5.2]
  def change
    change_table :shares do |t|
      t.references :revoker, polymorphic: true, index: true
      t.datetime :revoked_at
    end
  end
end
