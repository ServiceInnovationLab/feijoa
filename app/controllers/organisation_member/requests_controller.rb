# frozen_string_literal: true

class OrganisationMember::RequestsController < OrganisationMember::BaseController
  respond_to :html
  before_action :set_request, only: :show

  # GET /requests
  def index
    @requests = @organisation.requests
  end

  def new
    @request = Request.new(requester: @organisation)
  end

  def create
    @request = Request.new(document_type: request_params[:document_type],
                           note: request_params[:note],
                           requester: @organisation,
                           requestee: User.find_or_invite(request_params[:requestee_email]))
    if valid_params? && @request.valid?
      @request.save
      redirect_to organisation_member_request_path(@organisation, @request)
    else
      respond_with @request
    end
  end

  def show
    authorize @request, :show?
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_request
    @request = @organisation.requests.find(params[:id])
  end

  def valid_params?
    return true if request_params[:requestee_email].present?

    flash.now[:alert] = 'Please provide an email address to send this request to.'
    false
  end

  def request_params
    params.permit(:document_type, :requestee_email, :note)
  end
end
