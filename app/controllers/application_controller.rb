# frozen_string_literal: true

require 'application_responder'

class ApplicationController < ActionController::Base
  include Pundit
  self.responder = ApplicationResponder
  respond_to :html, :json
  # By default authenticated users can't access controller actions.
  #
  # This is deny-by-default, and setting it here will also cover the Devise
  # controllers which will prevent logged-in users from doing stuff like
  # requesting password resets when already logged in
  #
  # Overridden in User::BaseController
  before_action :redirect_authenticated_users

  protect_from_forgery with: :exception

  def redirect_authenticated_users
    return unless signed_in?

    flash.clear
    flash[:alert] = 'Already logged in'
    redirect_to(root_path)
  end
end
