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
    return unless signed_in?

    flash.clear
    flash[:alert] = 'Already logged in'
    redirect_to(root_path)
  end
end
