# frozen_string_literal: true

class Admin::BaseController < ApplicationController
  # Only Admins can access admin controller actions
  before_action :authenticate_admin!

  # Authenticated Admins are allowed to view Admin pages
  # This removes the deny-by-default added to ApplicationController
  skip_before_action :redirect_authenticated_users
end
