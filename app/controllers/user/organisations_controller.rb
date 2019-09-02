# frozen_string_literal: true

class User::OrganisationsController < User::BaseController
  def autocomplete
    render json: Organisation.search(params[:query],
                                     fields: [:name],
                                     match: :word_start,
                                     load: true,
                                     misspellings: { below: 10, edit_distance: 4 },
                                     track: { user_id: current_user.id })
  end
end
