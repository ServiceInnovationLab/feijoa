# frozen_string_literal: true

class User::RegistrationsController < Devise::RegistrationsController
  after_action :create_family_birth_records, only: :create

  private

  def create_family_birth_records
    # If the registration was rejected, return immediately
    return unless signed_in?

    # look for first.last@example.com
    name_parts = current_user.email.split('@').first.split('.')
    first_and_middle_names = name_parts.first.capitalize

    # default to Whanau if no family name was detected
    family_name = name_parts&.second&.capitalize || 'Whanau'

    DemoDataService.create_birth_record(first_and_middle_names, family_name)
    DemoDataService.create_family_birth_records(family_name)
  end
end
