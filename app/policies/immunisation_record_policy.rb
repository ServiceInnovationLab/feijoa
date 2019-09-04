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
end
