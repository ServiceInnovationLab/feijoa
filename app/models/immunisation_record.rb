# frozen_string_literal: true

class ImmunisationRecord < ApplicationRecord
  include Document
  has_associated_audits
end
