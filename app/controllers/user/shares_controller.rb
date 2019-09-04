# frozen_string_literal: true

class User::SharesController < ApplicationController
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
    @share.user = current_user
    authorize @share
  end

  # POST /shares
  def create
    require_valid_params

    @share = create_share_with_auditing

    if @share.valid?
      respond_with(@share, location: user_document_path(@share.document.document_type, @share.document.id))
    else
      respond_with(@share)
    end
  end

  def revoke
    @share.revoke(revoked_by: current_user)
    respond_with(@share, location: user_document_path(@share.document.document_type, @share.document.id))
  end

  private

  def create_share_with_auditing
    birth_record = current_user.documents(type: share_params[:document_type])
                               .find_by(id: share_params[:document_id])
    authorize birth_record, :share?
    birth_record.share_with(recipient: Organisation.find_by(id: share_params[:recipient_id]), user: current_user)
  end

  # Set the share, if it exists and is available to the current user
  def set_share
    @share = user_shares.find_by(params.permit(:id))
    authorize @share
  end

  # Require the params which will allow a valid model to be created
  #
  # The return value isn't useful, but this will raise an error if parameters
  # are missing
  def require_valid_params
    params
      .require(:share)
      .require(%i[document_id document_type recipient_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def share_params
    params.require(:share).permit(:document_id, :document_type, :recipient_id)
  end

  # The shares visible to the current user
  #
  # This is not as obvious as current_user.shares because shares are
  # soft-deleted with the 'discard' gem when they are revoked
  def user_shares
    policy_scope(current_user.shares).kept
  end
end
