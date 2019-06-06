# frozen_string_literal: true

class User::BaseController < ApplicationController
  before_action :authenticate_user!

  # rubocop:disable Rails/LexicallyScopedActionFilter
  skip_before_action :redirect_authenticated_users
  # rubocop:enable Rails/LexicallyScopedActionFilter
end
