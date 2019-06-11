# frozen_string_literal: true

require 'administrate/base_dashboard'

class BirthRecordDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    first_and_middle_names: Field::String,
    family_name: Field::String,
    date_of_birth: Field::String,
    place_of_birth: Field::String,
    sex: Field::String,
    parent_first_and_middle_names: Field::String,
    parent_family_name: Field::String,
    other_parent_first_and_middle_names: Field::String,
    other_parent_family_name: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    first_and_middle_names
    family_name
    date_of_birth
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    first_and_middle_names
    family_name
    date_of_birth
    place_of_birth
    sex
    parent_first_and_middle_names
    parent_family_name
    other_parent_first_and_middle_names
    other_parent_family_name
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    first_and_middle_names
    family_name
    date_of_birth
    place_of_birth
    sex
    parent_first_and_middle_names
    parent_family_name
    other_parent_first_and_middle_names
    other_parent_family_name
  ].freeze

  # Overwrite this method to customize how birth records are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(birth_record)
  #   "BirthRecord ##{birth_record.id}"
  # end
end
