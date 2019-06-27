# frozen_string_literal: true

class AdminUser::RegistrationsController < Devise::RegistrationsController
  include ControlMultipleLogins
end
