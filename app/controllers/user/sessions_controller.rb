# frozen_string_literal: true

class User::SessionsController < Devise::SessionsController
  skip_before_action :redirect_authenticated_users, only: %i[new create destroy]
  before_action :redirect_authenticated_users, only: :new, unless: :allow_multiple_logins

  # This is a workaround to allow testing of either value of this setting within a single test run
  def allow_multiple_logins
    Rails.configuration.allow_multiple_logins
  end
end
