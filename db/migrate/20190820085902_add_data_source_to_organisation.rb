class AddDataSourceToOrganisation < ActiveRecord::Migration[5.2]
  def change
    add_column :organisations, :data_source_name, :string
    # not an int, because some dataset might not use numbers
    add_column :organisations, :data_source_key, :string
    add_index :organisations, [:data_source_key, :data_source_name], unique: true
  end
end
