# frozen_string_literal: true

module AuthenticationHelper
  # True if the login ui should be visible
  def show_login_ui_for?(user_class)
    # Show the login ui if:
    # - Multiple logins are allowed in the main configuration
    # - The user isn't signed in yet
    # - The user is already signed in and so should see nav/sign_out for the appropriate user type
    Rails.configuration.allow_multiple_logins \
      || !signed_in? \
      || current_account.class <= user_class
  end
end
