# frozen_string_literal: true

class User::AuditsController < User::BaseController
  # GET
  def index
    # create distinct list of
    # - the audits of this user's actions
    # - the actions anyone has taken on this user's shares
    @audits = current_user.audits | shares_audits
  end

  private

  def shares_audits
    current_user.shares.map(&:audits).flatten
  end
end
