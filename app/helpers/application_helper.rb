# frozen_string_literal: true

module ApplicationHelper
  include ActiveSupport::Inflector

  def action_in_bem_format
    # split the full class name of the controller
    tokens = params['controller']&.split('/')

    path = dasherize(tokens[0..-2].join('-')).downcase
    controller = dasherize(tokens.last).downcase
    action = dasherize(params['action']).downcase

    return "#{path}__#{controller}--#{action}" if path.present?

    "#{controller}--#{action}"
  end
end
