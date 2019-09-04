# frozen_string_literal: true

class OrganisationMember::DashboardController < OrganisationMember::BaseController
  # GET
  def index
    authorize @organisation, :dashboard?
    @shares = policy_scope(@organisation.shares).unrevoked.order(updated_at: :desc)
    @requests = policy_scope(@organisation.requests).unresolved.order(updated_at: :desc)
  end
end
