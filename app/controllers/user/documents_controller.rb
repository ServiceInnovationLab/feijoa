# frozen_string_literal: true

class User::DocumentsController < User::BaseController
  before_action :set_document
  # GET
  def show
    @shares = @document.shares.where(user: current_user)
  end

  # POST
  def remove
    @document&.remove_from(current_user)
    flash[:alert] = 'Document removed.'
    redirect_to user_dashboard_index_path
  end

  private

  def set_document
    @document = current_user.documents(type: show_params[:type]).find_by(id: show_params[:id])
  end

  def show_params
    params.permit(:type, :id)
  end
end
