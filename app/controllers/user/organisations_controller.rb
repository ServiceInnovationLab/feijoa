# frozen_string_literal: true

class User::OrganisationsController < ApplicationController
  def autocomplete
    authorize Organisation, :index?
    render json: Organisation.search(params[:query],
                                     fields: [:name],
                                     match: :word_start,
                                     load: true,
                                     misspellings: { below: 10, edit_distance: 4 })
  end
end
