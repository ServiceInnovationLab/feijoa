# frozen_string_literal: true

class OrganisationsController < ApplicationController
  def index
    @organisations = policy_scope(Organisation.all)
  end
end
