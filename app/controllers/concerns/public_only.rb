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
    if current_admin_user
      flash.clear
      flash[:alert] = 'Already logged in as an Admin'
      redirect_to(authenticated_admin_user_root_path) && return
    elsif current_user
      flash.clear
      flash[:alert] = 'Already logged in as a User'
      redirect_to(authenticated_user_root_path) && return
    elsif current_organisation_user
      flash.clear
      flash[:alert] = 'Already logged in as an Organisation'
      redirect_to(authenticated_organisation_user_root_path) && return
    end
  end
end
