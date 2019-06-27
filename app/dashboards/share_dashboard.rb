require "administrate/base_dashboard"

class ShareDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user: Field::BelongsTo,
    recipient: Field::Polymorphic,
    birth_record: Field::BelongsTo,
    id: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    revoked_by_type: Field::String,
    revoked_by_id: Field::Number,
    revoked_at: Field::DateTime,
    last_accessed_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :user,
    :recipient,
    :birth_record,
    :id,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :user,
    :recipient,
    :birth_record,
    :id,
    :created_at,
    :updated_at,
    :revoked_by_type,
    :revoked_by_id,
    :revoked_at,
    :last_accessed_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :user,
    :recipient,
    :birth_record,
    :revoked_by_type,
    :revoked_by_id,
    :revoked_at,
    :last_accessed_at,
  ].freeze

  # Overwrite this method to customize how shares are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(share)
  #   "Share ##{share.id}"
  # end
end
