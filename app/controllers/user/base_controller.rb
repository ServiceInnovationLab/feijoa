# frozen_string_literal: true

class User::BaseController < ApplicationController
  # Only Users can access user controller actions
  before_action :authenticate_user!
end
