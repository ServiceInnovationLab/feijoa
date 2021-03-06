class CreateRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :requests do |t|
      t.references :requester, index: true, foreign_key: {to_table: :organisations}, null: false
      t.references :requestee, index: true, foreign_key: {to_table: :users}, null: false
      t.references :share, index: true
      t.string :document_type
      t.string :state
      t.text :note
      t.timestamps
    end
  end
end
