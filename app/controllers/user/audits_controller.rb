# frozen_string_literal: true

class User::AuditsController < User::BaseController
  # GET
  def index
    @audits = current_user.audits + shares_audits
  end

  private

  def shares_audits
    current_user.shares.map(&:audits).flatten
  end
end
