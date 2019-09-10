# frozen_string_literal: true

class User::ImmunisationRecordsController < ApplicationController
  def new
    @immunisation_record = ImmunisationRecord.new
    authorize @immunisation_record
  end

  def create
    @immunisation_record = ImmunisationRecord.new(create_params)
    authorize @immunisation_record
    if @immunisation_record.save
      @immunisation_record.add_to(current_user)
      respond_with(@immunisation_record, location: user_document_path('ImmunisationRecord', @immunisation_record.id))
    else
      render :new
    end
  end

  # PUT/PATCH
  def update
    @immunisation_record = ImmunisationRecord.find_by(id: params[:id])
    authorize @immunisation_record
    @immunisation_record.update_data(updated_by: current_user)
    redirect_back(fallback_location: user_document_path(type: 'ImmunisationRecord', id: @immunisation_record.id))
  end

  private

  def create_params
    params.require(:immunisation_record).permit(:nhi, :date_of_birth, :full_name)
  end
end
