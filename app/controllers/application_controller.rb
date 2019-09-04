# frozen_string_literal: true

require 'application_responder'

class ApplicationController < ActionController::Base
  respond_to :html, :json
  include Pundit

  before_action :authenticate_user!
  after_action :verify_authorized, except: :index, unless: :devise_controller?
  after_action :verify_policy_scoped, only: :index, unless: :devise_controller?

  self.responder = ApplicationResponder

  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to(request.referer || root_path)
  end
end
