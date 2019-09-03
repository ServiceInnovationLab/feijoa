# frozen_string_literal: true

require 'nhi_validator'

class NationalHealthIndexValidator < ActiveModel::Validator
  def validate(record)
    record.errors[:nhi] << (options[:message] || 'is not a valid NHI') unless NHIValidator.valid?(record.nhi)
  end

  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || 'is not a valid NHI') unless NHIValidator.valid?(value)
  end
end
