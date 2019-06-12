class BirthRecordService

  def self.query(params)
    # Early exit if required parameters aren't supplied.
    return [] unless (params.keys & required_keys).size == required_keys.size

    # Restrict the query to only required or optional keys
    permitted_params = params.select { |k, _v| (required_keys | optional_keys).include? k }

    BirthRecord.where(permitted_params)
  end

    # These are the required keys from the online birth certificate application at
  # https://certificates.services.govt.nz/certificate-order/certificate-events?type=birth-certificate
  #
  # Rejecting queries without the required keys prevents general fishing
  private_class_method def self.required_keys
    %w[
      first_and_middle_names
      family_name
      date_of_birth
    ]
  end

  # These are the required keys from the online birth certificate application at
  # https://certificates.services.govt.nz/certificate-order/certificate-events?type=birth-certificate
  #
  # Filtering to only the expected optional keys prevents fishing for fields
  # which aren't normally returned.
  private_class_method def self.optional_keys
    %w[
      place_of_birth
      parent_first_and_middle_names
      parent_family_name
      other_parent_first_and_middle_names
      other_parent_family_name
    ]
  end
end