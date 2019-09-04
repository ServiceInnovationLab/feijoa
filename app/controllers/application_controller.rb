# frozen_string_literal: true

require 'application_responder'

class ApplicationController < ActionController::Base
  include Pundit
  self.responder = ApplicationResponder
  respond_to :html, :json

  protect_from_forgery with: :exception
end
