# frozen_string_literal: true

class User::SessionsController < Devise::SessionsController
  skip_after_action :verify_policy_scoped
  skip_after_action :verify_authorized
end
