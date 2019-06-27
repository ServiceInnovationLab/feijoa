# frozen_string_literal: true

class OrganisationUser::SessionsController < Devise::SessionsController
  include ControlMultipleLogins
end
