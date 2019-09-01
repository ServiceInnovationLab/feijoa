class ImmunisationRecord < ApplicationRecord
  include Document
  has_associated_audits

end
