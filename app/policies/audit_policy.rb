# frozen_string_literal: true

class AuditPolicy < ApplicationPolicy
  def show?
    @record.user == @user || @record.auditable.user == @user
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      # audits where you took the action or where it was on your share
      scope.for_user_shares(@user).or(scope.where(user: @user))
    end
  end
end
