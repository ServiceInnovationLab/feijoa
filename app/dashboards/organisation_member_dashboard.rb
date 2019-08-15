# frozen_string_literal: true

require "administrate/base_dashboard"

class OrganisationMemberDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    organisation: Field::BelongsTo,
    user: Field::BelongsTo,
    id: Field::Number,
    role: Field::String
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :organisation,
    :user,
    :id,
    :role
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :organisation,
    :user,
    :id,
    :role
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :organisation,
    :user,
    :role
  ].freeze

  # Overwrite this method to customize how organisation members are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(organisation_member)
  #   "OrganisationMember ##{organisation_member.id}"
  # end
end
