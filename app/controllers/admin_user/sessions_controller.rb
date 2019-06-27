# frozen_string_literal: true

class AdminUser::SessionsController < Devise::SessionsController
  include ControlMultipleLogins
end
