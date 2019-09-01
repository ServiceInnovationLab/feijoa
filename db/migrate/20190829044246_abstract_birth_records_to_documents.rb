class AbstractBirthRecordsToDocuments < ActiveRecord::Migration[5.2]
  def up
    rename_table :birth_records_users, :user_documents
    add_column :user_documents, :document_type, :string
    rename_column :user_documents, :birth_record_id, :document_id
    add_column :shares, :document_type, :string
    rename_column :shares, :birth_record_id, :document_id
    execute("UPDATE shares SET document_type = 'BirthRecord' WHERE document_type IS null")
    execute("UPDATE user_documents SET document_type = 'BirthRecord' WHERE document_type IS null")
    execute("UPDATE requests SET document_type = 'BirthRecord' WHERE document_type = 'birth_record'")
  end

  def down
    rename_table :user_documents, :birth_records_users
    rename_column :birth_records_users, :document_id, :birth_record_id
    rename_column :shares, :document_id, :birth_record_id
    remove_column :birth_records_users, :document_type
    remove_column :shares, :document_type
    execute("UPDATE requests SET document_type = 'birth_record' WHERE document_type = 'BirthRecord'")
  end
end
