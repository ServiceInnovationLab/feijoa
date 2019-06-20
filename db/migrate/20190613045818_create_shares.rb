class CreateShares < ActiveRecord::Migration[5.2]
  def change
    create_table :shares do |t|
      t.references :user, null: false
      t.references :birth_record, null: false
      t.references :recipient, polymorphic: true, index: true, null: false

      t.timestamps
    end
  end
end
