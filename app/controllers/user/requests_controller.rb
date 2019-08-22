# frozen_string_literal: true

class User::RequestsController < User::BaseController
  respond_to :html
  before_action :set_request, only: %i[show respond decline]
  responders :flash

  # GET /requests
  def index
    @requests = current_user.requests
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
    document = current_user.documents(type: response_params[:document_type])
                           .find_by(id: response_params[:document_id])
    share = create_share(document)

    if share.save
      @request.update_attributes(share_id: share.id)
      @request.respond
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
  end

  def response_params
    params.permit(:document_id, :document_type)
  end

  def create_share(document)
    existing_share = Share.find_by(user: current_user, recipient: @request.requester, birth_record: document)
    return existing_share if existing_share.present?

    AuditedOperationsService.share_birth_record_with_recipient(
      user: current_user,
      birth_record: document,
      recipient: @request.requester
    )
  end
end
