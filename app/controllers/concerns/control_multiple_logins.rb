# frozen_string_literal: true

module ControlMultipleLogins
  extend ActiveSupport::Concern
  included do
    # rubocop:disable Rails/LexicallyScopedActionFilter
    skip_before_action :redirect_authenticated_users, only: %i[new create destroy]
    # rubocop:enable Rails/LexicallyScopedActionFilter
    before_action :redirect_authenticated_users, only: :new, unless: :allow_multiple_logins
  end

  private

  # This is a workaround to allow testing of either value of this setting within a single test run
  def allow_multiple_logins
    Rails.configuration.allow_multiple_logins
  end
end
