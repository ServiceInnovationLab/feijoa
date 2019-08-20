class AddDataSourceToOrganisation < ActiveRecord::Migration[5.2]
  def change
    add_column :organisations, :data_source_name, :string
    add_column :organisations, :data_source_id, :integer
    add_index :organisations, [:data_source_id, :data_source_name], unique: true
  end
end
