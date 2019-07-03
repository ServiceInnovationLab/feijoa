# frozen_string_literal: true

# Controls whether a visitor should be able to log in as multiple account
# types at once, based on the Rails.configuration.allow_multiple_logins
# setting.
#
# For example, AdminUser and User and OrganisationUser can all be signed in at
# the same time. Controllers will appropriately recognise the account they
# authenticate against, for example the User::BirthRecordsController will
# authenticated a logged in user and audit actions for them regardless of
# whether an AdminUser or OrganisationUser is also logged in.
#
# This is very useful for demoing because a single browser session can visit
# any page they're authenticated for. In contrast, this should never happen in
# a production web site because Users, AdminUsers, and OrganisationUsers are
# fundamentally different and there's no reason for a real world user to be
# logged in to more than one at the same time.
module ControlMultipleLogins
  extend ActiveSupport::Concern
  included do
    # rubocop:disable Rails/LexicallyScopedActionFilter
    skip_before_action :redirect_authenticated_users, only: %i[new create destroy]
    # rubocop:enable Rails/LexicallyScopedActionFilter
    before_action :redirect_authenticated_users, only: :new, unless: :allow_multiple_logins
  end

  private

  # This implementation allows testing of either value of this setting within a
  # single test run because allow_multiple_logins can be mocked in tests
  # regardless of the value of the underlying environment variable.
  def allow_multiple_logins
    Rails.configuration.allow_multiple_logins
  end
end
