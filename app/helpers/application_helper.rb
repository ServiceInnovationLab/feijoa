# frozen_string_literal: true

module ApplicationHelper
  def action_in_bem_format
    # TODO: doesn't handle multiple directories
    controller = request.params['controller'].gsub(%r{/}, '__')
    action = request.params['action']
    "#{controller}--#{action}"
  end
end
