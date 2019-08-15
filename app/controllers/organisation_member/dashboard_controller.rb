# frozen_string_literal: true

class OrganisationMember::DashboardController < OrganisationMember::BaseController
  # GET
  def index
    authorize @organisation, :dashboard?
  end
end
