# frozen_string_literal: true

class BirthRecord < ApplicationRecord
  include Document
  has_associated_audits

  def date_of_birth
    format_date(self[:date_of_birth])
  end

  def full_name
    # TODO: anglocentric
    "#{first_and_middle_names} #{family_name}"
  end

  def short_name
    # TODO: anglocentric
    "#{first_and_middle_names.first} #{family_name}"
  end

  # A unique identifier for the record
  #
  # This is important because we understand the real birth register doesn't
  # reveal the internal primary key for its records, so we need to create our
  # own to recognise when the same record is retrieved in future.
  #
  # This is an implementation detail which we don't HAVE to address unless we
  # connect to a real birth register but it seems prudent to address it as early
  # as possible if we have the opportunity.
  def primary_key_string
    key_attributes.join(' ').parameterize
  end

  # To abstract into a document class when there are multiple types of document
  def heading
    "#{family_name}, #{first_and_middle_names}"
  end

  def share_with(user:, recipient:)
    AuditedOperationsService.share_birth_record_with_recipient(
      user: user,
      birth_record: self,
      recipient: recipient
    )
  end

  def add_to(user)
    AuditedOperationsService.add_birth_record_to_user(
      user: user,
      birth_record: self
    )
  end

  def remove_from(user)
    AuditedOperationsService.remove_birth_record_from_user(
      user: user,
      birth_record_id: id
    )
  end

  private

  # TODO: be aware that these attributes could reveal information which the user
  # didn't already supply, like parent names
  #
  # Note gender is not included here. That's a choice we made because it's not
  # used in the online birth certificate application process
  def key_attributes
    [
      first_and_middle_names,
      family_name,
      date_of_birth,
      place_of_birth,
      parent_first_and_middle_names,
      parent_family_name,
      other_parent_first_and_middle_names,
      other_parent_family_name
    ]
  end

  def format_date(date)
    # This matches the format expected by the default bootstrap date field
    # widget. Will need to update tests if/when this changes
    date&.strftime('%d-%m-%Y')
  end
end
