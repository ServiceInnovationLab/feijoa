# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_08_20_085902) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.jsonb "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "birth_records", force: :cascade do |t|
    t.string "first_and_middle_names", default: "", null: false
    t.string "family_name", default: "", null: false
    t.date "date_of_birth"
    t.string "place_of_birth", default: "", null: false
    t.string "sex", default: "", null: false
    t.string "parent_first_and_middle_names", default: "", null: false
    t.string "parent_family_name", default: "", null: false
    t.string "other_parent_first_and_middle_names", default: "", null: false
    t.string "other_parent_family_name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["family_name"], name: "index_birth_records_on_family_name"
    t.index ["first_and_middle_names"], name: "index_birth_records_on_first_and_middle_names"
  end

  create_table "birth_records_users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "birth_record_id", null: false
    t.datetime "discarded_at"
    t.index ["birth_record_id", "user_id"], name: "index_birth_records_users_on_birth_record_id_and_user_id"
    t.index ["discarded_at"], name: "index_birth_records_users_on_discarded_at"
    t.index ["user_id", "birth_record_id"], name: "index_birth_records_users_on_user_id_and_birth_record_id"
  end

  create_table "organisation_members", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "organisation_id", null: false
    t.string "role"
    t.index ["organisation_id"], name: "index_organisation_members_on_organisation_id"
    t.index ["user_id"], name: "index_organisation_members_on_user_id"
  end

  create_table "organisation_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_organisation_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_organisation_users_on_reset_password_token", unique: true
  end

  create_table "organisations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address"
    t.string "email"
    t.string "contact_number"
    t.string "data_source_name"
    t.integer "data_source_id"
    t.index ["data_source_id", "data_source_name"], name: "index_organisations_on_data_source_id_and_data_source_name", unique: true
  end

  create_table "requests", force: :cascade do |t|
    t.bigint "requester_id", null: false
    t.bigint "requestee_id", null: false
    t.bigint "share_id"
    t.string "document_type"
    t.string "state"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["requestee_id"], name: "index_requests_on_requestee_id"
    t.index ["requester_id"], name: "index_requests_on_requester_id"
    t.index ["share_id"], name: "index_requests_on_share_id"
  end

  create_table "shares", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "birth_record_id", null: false
    t.string "recipient_type", null: false
    t.bigint "recipient_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "revoked_by_type"
    t.bigint "revoked_by_id"
    t.datetime "revoked_at"
    t.datetime "last_accessed_at"
    t.index ["birth_record_id"], name: "index_shares_on_birth_record_id"
    t.index ["recipient_type", "recipient_id"], name: "index_shares_on_recipient_type_and_recipient_id"
    t.index ["revoked_at"], name: "index_shares_on_revoked_at"
    t.index ["revoked_by_type", "revoked_by_id"], name: "index_shares_on_revoked_by_type_and_revoked_by_id"
    t.index ["user_id"], name: "index_shares_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "global_role"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "organisation_members", "organisations"
  add_foreign_key "organisation_members", "users"
  add_foreign_key "requests", "organisations", column: "requester_id"
  add_foreign_key "requests", "users", column: "requestee_id"
end
