# frozen_string_literal: true

class User::ImmunisationRecordsController < ApplicationController
  # PUT/PATCH
  def update
    @immunisation_record = ImmunisationRecord.find_by(id: params[:id])
    authorize @immunisation_record
    @immunisation_record.update_data(updated_by: current_user)
    redirect_back(fallback_location: user_document_path(type: 'ImmunisationRecord', id: @immunisation_record.id))
  end
end
