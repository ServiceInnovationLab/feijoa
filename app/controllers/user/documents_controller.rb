# frozen_string_literal: true

class User::DocumentsController < User::BaseController
  # GET
  def show
    @document = current_user.documents(type: show_params[:type]).find_by(id: show_params[:id])
    @shares = @document.shares.where(user: current_user)
  end

  private

  def show_params
    params.permit(:type, :id)
  end
end
