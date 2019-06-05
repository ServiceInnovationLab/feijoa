# frozen_string_literal: true

# Manage multiple kinds of Devise model
# Protected controller actions will bounce already logged-in users to
# an other appropriate action. e.g. use this to prevent logging in as
# as User and an Admin at the same time 
# As suggested at https://github.com/plataformatec/devise/wiki/How-to-Setup-Multiple-Devise-User-Models
module Accessible
  extend ActiveSupport::Concern
  included do
    before_action :check_user
  end

  protected

  def check_user
    if current_admin
      flash.clear
      flash[:notice] = 'Already logged in as an Admin'
      redirect_to(admin_root_path) && return
    elsif current_user
      flash.clear
      flash[:notice] = 'Already logged in as a User'
      redirect_to(user_root_path) && return
    end
  end
end
