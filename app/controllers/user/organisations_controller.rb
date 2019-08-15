# frozen_string_literal: true

class User::OrganisationsController < User::BaseController
  # GET
  def show
    @organisation = Organisation.find(params[:id])
    authorize @organisation, :show?
  end
end
