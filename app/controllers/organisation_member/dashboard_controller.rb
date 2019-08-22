# frozen_string_literal: true

class OrganisationMember::DashboardController < OrganisationMember::BaseController
  # GET
  def index
    authorize @organisation, :dashboard?
    @shares = @organisation.shares.order(updated_at: :desc)
    @requests = @organisation.requests.order(updated_at: :desc)
  end
end
