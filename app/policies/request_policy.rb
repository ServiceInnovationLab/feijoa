# frozen_string_literal: true

class RequestPolicy < ApplicationPolicy
  def show?
    @user == @record.requestee || @user.member_of?(@record.requester)
  end

  def decline?
    @user == @record.requestee
  end

  def respond?
    @user == @record.requestee
  end

  def cancel?
    @user.member_of?(@record.requester)
  end

  def update?
    @user == @record.requestee || @user.admin_for?(@record.requester)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      # It's request of me, or by one of my organisations
      scope.where(requestee: @user).or(scope.where(requester: @user.organisations.map(&:id)))
    end
  end
end
