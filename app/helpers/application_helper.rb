# frozen_string_literal: true

module ApplicationHelper
  include ActiveSupport::Inflector

  # Convert the controller and action of the current request into a BEM-style
  # string suitable for using as a HTML attribute
  #
  # Assumes that the controller and action parameters are already in the Rails
  # Inflector#parameterize format, e.g. lower case with underscores and slashes
  def action_in_bem_format
    # split the full class name of the controller
    tokens = params['controller']
             .split('/')
             .map(&:dasherize)

    path = tokens[0..-2].join('-')
    controller = tokens.last
    action = params['action'].dasherize

    return "#{path}__#{controller}--#{action}" if path.present?

    "#{controller}--#{action}"
  end

  # Returns 'devise-controller' if the controller inherits from
  # Devise::ApplicationController
  #
  # Suitable for use as a dynamically inserted CSS class, e.g:
  #
  # <body class="<%= devise_flag %>">
  def devise_flag
    'devise-controller' if controller.class < DeviseController
  end
end
