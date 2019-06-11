# frozen_string_literal: true

class User::BirthRecordController < User::BaseController
  # GET
  def show
    @birth_record = current_user.birth_records.find_by(params.permit(:id))
    raise ActiveRecord::RecordNotFound unless @birth_record
  end
end
