# frozen_string_literal: true

class SharePolicy < ApplicationPolicy
  def show?
    @user.present? && (
      @user == @record.user || (@user.member_of?(@record.recipient) && @record.unrevoked?)
    )
  end

  def update?
    @user.present? && (
      @user == @record.user || (@user.admin_for?(@record.recipient) && @record.unrevoked?)
    )
  end

  def destroy?
    @user.present? && @user == @record.user
  end

  def revoke?
    @user.present? && @user == @record.user
  end

  def create?
    # They are creating a share for their own user
    # and it's for a document in their collection
    @user == @record.user && user_has_document
  end

  private

  def user_has_document
    @user.documents(type: @record.document_type)
         .find_by(id: @record.document_id)
         .present?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.nil?
        scope.none
      else
        # It's my share, or it's shared with my organisations
        scope.where(user: @user).or(scope.where(recipient: @user.organisations.map(&:id)))
      end
    end
  end
end
