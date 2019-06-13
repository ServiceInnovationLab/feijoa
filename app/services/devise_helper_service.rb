# frozen_string_literal: true

# Helper implementations moved here to slim down controllers and make unit
# testing easier
class DeviseHelperService
  class << self
    include Rails.application.routes.url_helpers
  end

  def self.model_root_path(resource)
    return authenticated_admin_user_root_path if resource.is_a? AdminUser

    return authenticated_user_root_path if resource.is_a? User

    root_path
  end
end
