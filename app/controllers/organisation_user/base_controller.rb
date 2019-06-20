# frozen_string_literal: true

class OrganisationUser::BaseController < ApplicationController
  # Only Organisations can access admin controller actions
  before_action :authenticate_organisation_user!

  # Authenticated Organisations are allowed to view Organisation pages
  # This removes the deny-by-default added to ApplicationController
  skip_before_action :redirect_authenticated_users
end
