# frozen_string_literal: true

class User::RequestsController < User::BaseController
  respond_to :html
  before_action :set_request, only: %i[show decline]
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
    authorize @request, :update?
    @request.decline
    flash.now[:notice] = 'You have declined this request.'
    render :show
  end

  private

  # Set the request, if it exists and is available to the current user
  def set_request
    @request = current_user.requests.find(params[:id])
  end
end
