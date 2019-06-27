# frozen_string_literal: true

class User::RegistrationsController < Devise::RegistrationsController
  skip_before_action :redirect_authenticated_users, only: %i[new create destroy]
end
