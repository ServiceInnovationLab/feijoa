# frozen_string_literal: true

class User::AuditsController < User::BaseController
  # GET
  def index
    @audits = user_audits
  end

  private

  # Get the audits for this user 
  #
  # BirthRecordsUser (the join table), Share, and View (TODO not implemented
  # yet, requires the 'view shared birth records' feature) audits are all
  # associated with a BirthRecord so the easiest way to gat a user's audits is
  # to get the associated audits for their birth records.
  def user_audits
    current_user
      .birth_records
      .map(&:own_and_associated_audits)
      .flatten
  end
end
