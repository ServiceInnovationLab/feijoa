# frozen_string_literal: true

class User::RegistrationsController < Devise::RegistrationsController
  include ControlMultipleLogins
end
