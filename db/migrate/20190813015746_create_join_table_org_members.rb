class CreateJoinTableOrgMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :organisation_members do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :organisation, index: true, foreign_key: true, null: false
      t.string :role
    end
  end
end
