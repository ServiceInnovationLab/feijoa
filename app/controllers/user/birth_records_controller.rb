# frozen_string_literal: true

class User::BirthRecordsController < ApplicationController
  # GET
  def index
    redirect_to user_dashboard_index_path
  end

  # GET
  def show
    redirect_to user_document_path(Document::BIRTH_RECORD, params.permit(:id))
  end

  # GET
  def find
    authorize BirthRecord, :find?
  end

  # POST query
  def query
    # Only search on keys where a value was provided. The query service checks
    # that all required params have a value.
    supplied_params = query_params.to_h.select { |_k, v| v.present? }

    @results = BirthRecordService.query(supplied_params)
    policy_scope(@results)
    skip_authorization # we're using policy scope instead here
  end

  # POST
  #
  # Attempts to add a record which is already attached will be ignored (by
  # 'distinct' modifier on User.birth_records).
  def add
    @birth_record = BirthRecord.find_by(params.permit(:id))
    authorize @birth_record
    @birth_record&.add_to(current_user)

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
