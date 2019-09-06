# frozen_string_literal: true

class OrganisationsController < ApplicationController
  def index
    @organisations = policy_scope(Organisation.all)
                     .order(:name)
                     .paginate(page: params[:page], per_page: 30)
  end
end
