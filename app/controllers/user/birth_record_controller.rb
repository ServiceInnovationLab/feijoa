# frozen_string_literal: true

class User::BirthRecordController < User::BaseController
  # GET
  def show
    @birth_record = current_user.birth_records.find_by(params.permit(:id))
    not_found unless @birth_record
  end

  # GET
  def search; end

  private

  def search_params; end
end
