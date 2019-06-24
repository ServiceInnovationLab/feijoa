# frozen_string_literal: true

class User::SharesController < User::BaseController
  respond_to :html, :json
  before_action :set_share, only: :show
  responders :flash

  # GET /shares
  def index
    @shares = current_user.shares
  end

  # GET /shares/1
  def show; end

  # GET /shares/new
  def new
    # pre-fill any supplied params (e.g. birth_record if creating from the birth
    # record page)
    @share = if params.keys.include? 'share'
               Share.new(share_params)
             else
               Share.new
             end

    @organisations = OrganisationUser.all
  end

  # POST /shares
  def create
    @share = Share.new(share_params)
    # shares are always associated with the current user
    @share.user = current_user
    # we currently only allow shares to Organisations
    @share.recipient_type = OrganisationUser.name
    if @share.save
      respond_with(@share, location: user_birth_record_path(@share.birth_record))
    else
      respond_with(@share)
    end
  end

  def destroy
    @share = Share.find_by!(id: params[:id], user_id: current_user.id)
    @share.destroy
    respond_with(@share, location: user_birth_record_path(@share.birth_record))
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_share
    @share = current_user.shares.find_by(params.permit(:id))
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def share_params
    params.require(:share).permit(:birth_record_id, :recipient_type, :recipient_id)
  end
end
