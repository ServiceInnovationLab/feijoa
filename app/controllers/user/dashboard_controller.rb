# frozen_string_literal: true

class User::DashboardController < ApplicationController
  # GET
  def index
    @organisations = current_user.organisations
    @requests = policy_scope(current_user.requests.unresolved, policy_scope_class: RequestPolicy::Scope)
    @documents = current_user.documents
  end
end
