# frozen_string_literal: true

class RequestPolicy
  attr_reader :request, :user

  def initialize(user, request)
    @user = user
    @request = request
  end

  def show?
    user == request.requestee || user.member_of?(request.requester)
  end

  def decline?
    user == request.requestee
  end

  def cancel?
    user.member_of?(request.requester)
  end

  def update?
    user == request.requestee || user.admin_for?(request.requester)
  end
end
