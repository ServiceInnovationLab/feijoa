# frozen_string_literal: true

class User::DashboardController < User::BaseController
  # GET
  def index
    @organisations = current_user.organisations
  end
end
