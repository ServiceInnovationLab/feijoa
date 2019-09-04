# frozen_string_literal: true

class User::AuditsController < ApplicationController
  # GET
  def index
    # create distinct list of
    # - the audits of this user's actions
    # - the actions anyone has taken on this user's shares
    @audits = user_audits | shares_audits
  end

  private

  def user_audits
    policy_scope(current_user.audits).order(created_at: :desc)
  end

  def shares_audits
    policy_scope(current_user.shares).order(created_at: :desc).map(&:audits).flatten
  end
end
