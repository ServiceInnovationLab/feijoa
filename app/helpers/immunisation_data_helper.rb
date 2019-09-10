# frozen_string_literal: true

module ImmunisationDataHelper
  def fhir_data(immunisation_record)
    return nil if immunisation_record.data.blank?

    immunisation_record.data.map do |datapoint|
      FHIR::Immunization.new(datapoint)
    end
  end
end
