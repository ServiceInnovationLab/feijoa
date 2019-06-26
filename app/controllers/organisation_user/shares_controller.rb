# frozen_string_literal: true

class OrganisationUser::SharesController < OrganisationUser::BaseController
  before_action :set_share, only: :show

  # GET /shares
  def index
    @shares = current_organisation_user.shares
  end

  # GET /shares/1
  def show; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_share
    @share = current_organisation_user.shares.find_by(params.permit(:id))
  end
end
