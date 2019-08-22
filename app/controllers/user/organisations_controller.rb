# frozen_string_literal: true

class User::OrganisationsController < User::BaseController
  # GET
  def show
    @organisation = Organisation.find(params[:id])
    authorize @organisation, :show?
  end

  def autocomplete
    render json: Organisation.search(params[:query],
                                     fields: [:name],
                                     match: :word_start,
                                     limit: 10,
                                     load: true,
                                     misspellings: { below: 10, edit_distance: 2 })
  end
end
