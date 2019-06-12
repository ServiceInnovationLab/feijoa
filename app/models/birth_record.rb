# frozen_string_literal: true

class BirthRecord < ApplicationRecord
  has_and_belongs_to_many :users

  def date_of_birth
    format_date(self[:date_of_birth])
  end

  def parent_date_of_birth
    format_date(self[:parent_date_of_birth])
  end

  def other_parent_date_of_birth
    format_date(self[:other_parent_date_of_birth])
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

  private

  def key_attributes
    [
      self.first_and_middle_names,
      self.family_name,
      self.date_of_birth,
      self.place_of_birth,
      self.parent_first_and_middle_names,
      self.parent_family_name,
      self.other_parent_first_and_middle_names,
      self.other_parent_family_name,
    ]
  end

  def format_date(d)
    # This matches the format expected by the default bootstrap date field
    # widget. Will need to update tests if this changes
    d&.strftime('%d-%m-%Y')
  end
end
