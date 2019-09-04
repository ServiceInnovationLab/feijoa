# frozen_string_literal: true

class OrganisationMember::SharesController < OrganisationMember::BaseController
  before_action :set_share, only: :show

  # GET /shares
  def index
    @shares = policy_scope(@organisation.shares)
  end

  # GET /shares/1
  def show
    @document = @share.access(accessed_by: current_user)
    authorize @document
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_share
    @share = @organisation.shares.find_by(params.permit(:id))
    authorize @share
  end
end
