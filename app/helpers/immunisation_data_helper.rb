# frozen_string_literal: true

module ImmunisationDataHelper
  def fhir_data(immunisation_record)
    immunisation_record.data.map do |datapoint|
      FHIR::Immunization.new(datapoint)
    end
  end
end
