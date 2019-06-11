# frozen_string_literal: true

# Helper implementations moved here to slim down controllers and make unit
# testing easier
class DeviseHelperService
  class << self
    include Rails.application.routes.url_helpers
  end

  def self.model_root_path(resource)
    return admin_user_index_path if resource.is_a? AdminUser

    return user_index_path if resource.is_a? User

    root_path
  end
end
