# frozen_string_literal: true

class User::RequestsController < ApplicationController
  respond_to :html
  before_action :set_request, only: %i[show respond decline]
  responders :flash

  # GET /requests
  def index
    @requests = policy_scope(current_user.requests)
  end

  # GET /requests/1
  def show
    authorize @request, :show?
    @request.view
  end

  # POST /requests/1/decline
  def decline
    authorize @request, :decline?
    @request.decline
    flash.now[:notice] = 'You have declined this request.'
    render :show
  end

  # POST /requests/1/respond
  def respond
    authorize @request, :respond?
    document = find_document
    share = find_or_create_share(document)

    if share && @request.respond_with_share(share)
      flash.now[:notice] = 'You have shared this document.'
    else
      flash.now[:alert] = 'There was a problem sharing this document. Please try again.'
    end
    render :show
  end

  private

  # Set the request, if it exists and is available to the current user
  def set_request
    @request = current_user.requests.find(params[:id])
    authorize @request
  end

  def response_params
    params.permit(:document_id, :document_type)
  end

  def find_document
    current_user.documents(type: response_params[:document_type])
                .find_by(id: response_params[:document_id])
  end

  def find_or_create_share(document)
    existing_share = Share.kept.find_by(user: current_user, recipient: @request.requester, document: document)
    return existing_share if existing_share.present?

    document.share_with(user: current_user, recipient: @request.requester)
  end
end
