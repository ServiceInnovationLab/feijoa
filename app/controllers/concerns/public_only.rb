# frozen_string_literal: true

# Manage multiple kinds of Devise model
# Protected controller actions will bounce already logged-in users to
# an other appropriate action. e.g. use this to prevent logging in as
# as User and an Admin at the same time
# As suggested at https://github.com/plataformatec/devise/wiki/How-to-Setup-Multiple-Devise-User-Models
module PublicOnly
  extend ActiveSupport::Concern
  included do
    before_action :redirect_authenticated_users
  end

  protected

  def redirect_authenticated_users
    return unless logged_in?

    flash.clear
    flash[:alert] = "Already logged in as an #{current_account.to_s.downcase}"
    redirect_to(root_path_for_user) && return
  end

  def root_path_for_user
    return authenticated_user_root_path if current_user
    return authenticated_admin_user_root_path if current_admin_user

    authenticated_organisation_user_root_path if current_organisation_user
  end

  def logged_in?
    !current_account.nil?
  end
end
