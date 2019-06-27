# frozen_string_literal: true

class OrganisationUser::RegistrationsController < Devise::RegistrationsController
  include ControlMultipleLogins
end
