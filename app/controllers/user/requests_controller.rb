# frozen_string_literal: true

class User::RequestsController < User::BaseController
  respond_to :html, :json
  before_action :set_request, only: %i[show]
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

  private

  # Set the request, if it exists and is available to the current user
  def set_request
    @request = current_user.requests.find(params[:id])
  end
end
