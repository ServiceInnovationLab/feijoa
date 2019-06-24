# frozen_string_literal: true

class User::AuditsController < User::BaseController
  # GET
  def index
    @audits = current_user.audits
  end
end
