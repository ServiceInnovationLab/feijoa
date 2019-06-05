# frozen_string_literal: true

class User::BaseController < ApplicationController
  before_action :authenticate_user!
end
