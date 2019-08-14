class AddMoreFieldsToOrganisations < ActiveRecord::Migration[5.2]
  def change
    add_column :organisations, :address, :string
    add_column :organisations, :email, :string
    add_column :organisations, :contactNo, :string
  end
end
