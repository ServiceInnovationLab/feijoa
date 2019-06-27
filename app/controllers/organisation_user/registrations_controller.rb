# frozen_string_literal: true

class OrganisationUser::RegistrationsController < Devise::RegistrationsController
  skip_before_action :redirect_authenticated_users, only: %i[new create destroy]
end
