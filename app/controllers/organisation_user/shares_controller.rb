# frozen_string_literal: true

class OrganisationUser::SharesController < OrganisationUser::BaseController
  before_action :set_share, only: :show

  # GET /shares
  def index
    @shares = current_organisation_user.shares
  end

  # GET /shares/1
  def show
    @official_birth_record = AuditedOperationsService.access_shared_birth_record(
      logged_identity: current_account,
      share: @share
    )
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_share
    @share = current_organisation_user.shares.find_by(params.permit(:id))
  end
end
