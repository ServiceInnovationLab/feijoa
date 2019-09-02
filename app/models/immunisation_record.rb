# frozen_string_literal: true

class ImmunisationRecord < ApplicationRecord
  include Document
  has_associated_audits
  validates :nhi, presence: true, national_health_index: true
  validates :date_of_birth, presence: true
  validates :full_name, presence: true
  before_create { nhi.upcase! }

  
end
