# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    return root_path if resource.blank?

    stored_location_for(resource) || model_root_path(resource)
  end

  def model_root_path(resource)
    return admin_index_path if resource.is_a? Admin

    return user_index_path if resource.is_a? User

    root_path
  end
end
