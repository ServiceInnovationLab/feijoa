class AddNameToOrganisationUser < ActiveRecord::Migration[5.2]
  def change
    add_column :organisation_users, :name, :string
  end
end
