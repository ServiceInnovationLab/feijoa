# frozen_string_literal: true

class BirthRecordPolicy < ApplicationPolicy
  def show?
    true
  end

  def find?
    true
  end

  def add?
    true
  end

  def remove?
    true
  end

  def share?
    user.birth_records.includes record
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
