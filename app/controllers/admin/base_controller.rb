# frozen_string_literal: true

class Admin::BaseController < ApplicationController
  # Only Admins can access admin controller actions
  before_action :authenticate_admin!

  # Authenticated users are allowed to view User pages
  # This removes the deny-by-default added to ApplicationController
  # rubocop:disable Rails/LexicallyScopedActionFilter
  skip_before_action :redirect_authenticated_users
  # rubocop:enable Rails/LexicallyScopedActionFilter
end
