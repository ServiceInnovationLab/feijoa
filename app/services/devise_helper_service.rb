# frozen_string_literal: true

# Helper implementations moved here to slim down controllers and make unit
# testing easier
class DeviseHelperService
  class << self
    include Rails.application.routes.url_helpers
  end

  # TODO: due to other refactoring this is redundant. If we set x_root_path in
  # routes.rb directing any user to '/' will be contextually appropriate
  def self.model_root_path(resource)
    return authenticated_admin_user_root_path if resource.is_a? AdminUser

    return authenticated_user_root_path if resource.is_a? User

    return authenticated_organisation_user_root_path if resource.is_a? OrganisationUser

    root_path
  end
end
