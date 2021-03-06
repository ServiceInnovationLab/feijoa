# frozen_string_literal: true

class ImmunisationRecord < ApplicationRecord
  include Document
  has_associated_audits

  validates :nhi, presence: true, national_health_index: true
  validates :date_of_birth, presence: true
  validates :full_name, presence: true
  before_create { nhi.upcase! }

  def heading
    full_name
  end

  def last_data_update
    audits.where(comment: update_audit_comment).last
  end

  def update_data(updated_by:)
    fetcher = ImmunisationDataFetcher.new(self)
    imms_data = fetcher.fetch_data
    return false if imms_data.blank?

    AuditedOperationsService.update_immunisation_data(
      user: updated_by,
      immunisation_record: self,
      new_data: imms_data
    )
  end
end
