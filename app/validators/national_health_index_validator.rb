# frozen_string_literal: true

require 'nhi_validator'

class NationalHealthIndexValidator < ActiveModel::Validator
  def validate(record)
    unless NHIValidator.valid?(record.nhi)
      record.errors[:nhi] << (options[:message] || 'is not a valid NHI')
    end
  end

  def validate_each(record, attribute, value)
    unless NHIValidator.valid?(value)
      record.errors[attribute] << (options[:message] || 'is not a valid NHI')
    end
  end
end
