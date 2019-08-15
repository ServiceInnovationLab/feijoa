# frozen_string_literal: true

class OrganisationMember::BaseController < User::BaseController
  # Controllers for users acting on behalf of organisations

  before_action :set_organisation

  def set_organisation
    @organisation = Organisation.find(params[:organisation_id])
    authorize @organisation, :act_as?
  end
end
