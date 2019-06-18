# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # By default authenticated users can't access controller actions.
  #
  # This is deny-by-default, and setting it here will also cover the Devise
  # controllers which will prevent logged-in users from doing stuff like
  # requesting password resets or logging in as an Admin while already a User
  #
  # See User::BaseController and Admin::BaseController where the appropriate
  # user models are explicitly allowed.
  include PublicOnly

  protect_from_forgery with: :exception

  devise_group :account, contains: %i[user admin_user organisation_user]
end
