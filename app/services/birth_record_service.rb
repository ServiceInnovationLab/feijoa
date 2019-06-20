# frozen_string_literal: true

# A service which wraps up the business logic of querying for birth records.
#
# All birth record queries in the application should pass through this service
# rather than using the ActiveRecord queries directly.
class BirthRecordService
  # Search for a single BirthRecord matching the supplied parameters hash
  def self.query(params, case_insensitive_keys: self.case_insensitive_keys)
    return [] unless all_required_keys_are_present?(params)

    # make sure we only search on permitted params
    permitted_params = only_permitted_keys(params)

    # split the permitted params into case sensitive and case insensitive lists
    exact_match_params = permitted_params.except(*case_insensitive_keys)
    case_insensitive_params = permitted_params.slice(*case_insensitive_keys)

    # construct a query with WHERE clauses for all the exact match params
    query = BirthRecord.where(exact_match_params)

    # Append another where clause for each case insensitive param, using
    # postgres LOWER. Indexes could be added on LOWER(column) to improve
    # performance but that would be premature optimisation right now.
    #
    # The query isn't executed until it's evaluated so this doesn't cause
    # an additional database lookup for each clause
    case_insensitive_params.each do |key, value|
      query = query.where("LOWER(#{BirthRecord.connection.quote_column_name(key)})=LOWER(?)", value)
    end

    query
  end

  def self.permitted_keys
    required_keys | optional_keys
  end

  # These are the required keys from the online birth certificate application at
  # https://certificates.services.govt.nz/certificate-order/certificate-events?type=birth-certificate
  #
  # Rejecting queries without the required keys prevents general fishing
  def self.required_keys
    %w[
      first_and_middle_names
      family_name
      date_of_birth
    ]
  end

  # These are the optional keys from the online birth certificate application at
  # https://certificates.services.govt.nz/certificate-order/certificate-events?type=birth-certificate
  #
  # Filtering to only the expected optional keys prevents fishing for fields
  # which aren't normally returned.
  def self.optional_keys
    %w[
      place_of_birth
      parent_first_and_middle_names
      parent_family_name
      other_parent_first_and_middle_names
      other_parent_family_name
    ]
  end

  # Keys (already included in #required_keys or #optional_keys) which should be
  # case-insensitive for database queries
  def self.case_insensitive_keys
    %w[
      first_and_middle_names
      family_name
      place_of_birth
      parent_first_and_middle_names
      parent_family_name
      other_parent_first_and_middle_names
      other_parent_family_name
    ]
  end

  # Filter the params to only required or optional keys
  private_class_method def self.only_permitted_keys(params)
    params.slice(*permitted_keys)
  end

  # Check that all required keys are present in the params
  private_class_method def self.all_required_keys_are_present?(params)
    (required_keys - params.keys).empty?
  end
end
