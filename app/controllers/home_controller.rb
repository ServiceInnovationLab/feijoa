# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :check_user
  def index; end
end
