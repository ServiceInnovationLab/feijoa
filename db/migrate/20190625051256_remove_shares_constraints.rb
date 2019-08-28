class RemoveSharesConstraints < ActiveRecord::Migration[5.2]
  def change
    remove_index :shares,
      name: 'index_unique_shares'
  end
end
