# frozen_string_literal: true

class User::DashboardController < User::BaseController
  # GET
  def index
    @organisations = current_user.organisations
    @requests = current_user.requests.unresolved
    @documents = current_user.documents
  end
end
