# frozen_string_literal: true

require 'rails_helper'

describe AuditPolicy do
  subject { AuditPolicy.new(user, share) }

  let(:user) { FactoryBot.create(:user) }
  let(:some_other_guy) { FactoryBot.create(:user) }
  let(:share) { FactoryBot.create(:share, user: user) }
  let!(:audit_by_user) { Audit.create(user: user) }
  let!(:audit_for_share) { Audit.create(user: some_other_guy, auditable: share) }
  let!(:audit_for_something_else) { Audit.create(user: some_other_guy, auditable: user) }

  describe 'policy scope' do
    subject { AuditPolicy::Scope.new(user, Audit.all).resolve }
    it 'includes audits by the user' do
      expect(subject).to include(audit_by_user)
    end
    it 'includes audits for shares the user has made' do
      expect(subject).to include(audit_for_share)
    end
    it "doesn't include other audits" do
      expect(subject).not_to include(audit_for_something_else)
    end
  end
end
