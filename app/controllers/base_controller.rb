# frozen_string_literal: true

class BaseController < ApplicationController
  # Any users can see public pages regardless of whether they are logged in
  skip_before_action :redirect_authenticated_users

  # no authentication is required for public pages
end