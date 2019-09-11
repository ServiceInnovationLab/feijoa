# frozen_string_literal: true

class ImmunisationRecordPolicy < ApplicationPolicy
  def show?
    true
  end

  def share?
    user.immunisation_records.includes record
  end

  def remove?
    user.immunisation_records.includes record
  end

  def update?
    user.immunisation_records.includes record || record.shared_with?(user)
  end

  def create?
    true
  end

  def new?
    true
  end
end
