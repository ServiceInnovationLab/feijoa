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
    if @request.save
      redirect_to organisation_member_request_path(@organisation, @request)
    else
      flash.now[:notice] = 'Successfully created request.'
      render :new
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

  def request_params
    params.require(:request).permit(:document_type, :requestee_email, :note)
  end
end
