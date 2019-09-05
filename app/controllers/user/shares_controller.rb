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
    @share = Share.new(share_params)
    @share.user = current_user
    authorize @share
    respond_with(@share, location: user_document_path(@share.document.document_type, @share.document.id))
  end

  def revoke
    @share.revoke(revoked_by: current_user)
    respond_with(@share, location: user_document_path(@share.document.document_type, @share.document.id))
  end

  private

  # Set the share, if it exists and is available to the current user
  def set_share
    @share = user_shares.find_by(params.permit(:id))
    authorize @share
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
