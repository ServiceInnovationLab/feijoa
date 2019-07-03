# frozen_string_literal: true

class User::SharesController < User::BaseController
  respond_to :html, :json
  before_action :set_share, only: %i[show revoke]
  responders :flash

  # GET /shares
  def index
    @shares = user_shares
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
    require_valid_params

    birth_record = current_user.birth_records.find(share_params['birth_record_id'].to_i)
    recipient = OrganisationUser.find(share_params['recipient_id'].to_i)

    @share = AuditedOperationsService.share_birth_record_with_recipient(
      user: current_user,
      birth_record: birth_record,
      recipient: recipient
    )

    if @share.valid?
      respond_with(@share, location: user_birth_record_path(@share.birth_record))
    else
      respond_with(@share)
    end
  end

  def revoke
    AuditedOperationsService.revoke_share(share: @share, user: current_account)
    respond_with(@share, location: user_birth_record_path(@share.birth_record))
  end

  private

  # Set the share, if it exists and is available to the current user
  def set_share
    @share = user_shares.find_by(params.permit(:id))
  end

  # Require the params which will allow a valid model to be created
  #
  # The return value isn't useful, but this will raise an error if parameters
  # are missing
  def require_valid_params
    params
      .require(:share)
      .require([:birth_record_id, :recipient_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def share_params
    params.require(:share).permit(:birth_record_id, :recipient_id)
  end

  # The shares visible to the current user
  #
  # This is not as obvious as current_user.shares because shares are
  # soft-deleted with the 'discard' gem when they are revoked
  def user_shares
    current_user.shares.kept
  end
end
