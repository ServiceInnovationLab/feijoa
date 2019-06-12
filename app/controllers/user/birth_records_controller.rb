# frozen_string_literal: true

class User::BirthRecordsController < User::BaseController
  # GET
  def index
    @birth_records = current_user.birth_records
  end

  # GET
  def show
    @birth_record = current_user.birth_records.find_by(params.permit(:id))
    raise ActiveRecord::RecordNotFound unless @birth_record
  end

  # GET find
  def find
    @birth_record = BirthRecord.new
    @results = []
  end

  # POST query
  def query
    @birth_record = BirthRecord.new(query_params)
    @results = BirthRecord.where(query_params)
    render 'find'
  end

  # POST
  #
  # Attempts to add a record which is already attached will be ignored (by
  # 'distinct' modifier on User.birth_records).
  def add
    current_user.birth_records << BirthRecord.find(params.permit(:id)[:id].to_i)
    redirect_to user_birth_records_path
  end

  # POST
  #
  # Attempts to remove a record which is not attached or doesn't exist will be
  # silently ignored.
  def remove
    begin
      current_user.birth_records.delete(params.permit(:id)[:id].to_i)
    rescue ActiveRecord::RecordNotFound
    end

    redirect_to user_birth_records_path
  end

  private

  def query_params
    params
      .require(:birth_record)
      .permit(
        :first_and_middle_names,
        :family_name,
        :place_of_birth,
        :date_of_birth
      )
  end
end
