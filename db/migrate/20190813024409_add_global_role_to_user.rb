class AddGlobalRoleToUser < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.string :global_role
    end
  end
end
