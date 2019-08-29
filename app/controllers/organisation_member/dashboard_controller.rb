# frozen_string_literal: true

class OrganisationMember::DashboardController < OrganisationMember::BaseController
  # GET
  def index
    authorize @organisation, :dashboard?
    @shares = @organisation.shares.unrevoked.order(updated_at: :desc)
    @requests = @organisation.requests.unresolved.order(updated_at: :desc)
  end
end
