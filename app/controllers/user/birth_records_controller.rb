# frozen_string_literal: true

class User::BirthRecordsController < User::BaseController
  # GET
  def index
    @birth_records = current_user.birth_records
  end

  # GET
  def show
    @birth_record = current_user.birth_records.find_by!(params.permit(:id))
    @shares = @birth_record.shares.where(user: current_user)
  end

  # POST query
  def query
    # Only search on keys where a value was provided. The query service checks
    # that all required params have a value.
    supplied_params = query_params.to_h.select { |_k, v| v.present? }

    @results = BirthRecordService.query(supplied_params)
  end

  # POST
  #
  # Attempts to add a record which is already attached will be ignored (by
  # 'distinct' modifier on User.birth_records).
  def add
    BirthRecordService.add(
      user: current_user,
      birth_record: BirthRecord.find_by(params.permit(:id))
    )

    redirect_to user_birth_records_path
  end

  # POST
  #
  # Attempts to remove a record which is not attached or doesn't exist will be
  # silently ignored.
  def remove
    BirthRecordService.remove(
      user: current_user,
      birth_record_id: params.permit(:id)[:id].to_i
    )

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
        :date_of_birth,
        :parent_first_and_middle_names,
        :parent_family_name,
        :other_parent_first_and_middle_names,
        :other_parent_family_name
      )
  end
end
