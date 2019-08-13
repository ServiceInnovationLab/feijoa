class AddRoleToOrganisationsUser < ActiveRecord::Migration[5.2]
  def change
    change_table :organisations_users do |t|
      t.string :role
    end
  end
end
