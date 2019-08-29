# frozen_string_literal: true

require 'rails_helper'

describe SharePolicy do
  subject { SharePolicy.new(user, share) }

  let(:organisation) { FactoryBot.create(:organisation) }
  let(:sharer) { FactoryBot.create(:user) }
  let(:organisation_admin) do
    user = FactoryBot.create(:user)
    FactoryBot.create(:organisation_member, user: user, organisation: organisation, role: 'admin')
    user.reload
  end
  let(:organisation_staff) do
    user = FactoryBot.create(:user)
    FactoryBot.create(:organisation_member, user: user, organisation: organisation, role: 'staff')
    user.reload
  end

  let(:share) { FactoryBot.create(:share, user: sharer, recipient: organisation) }

  shared_examples 'can not do anything' do
    it { should_not permit(:show) }
    it { should_not permit(:update) }
    it { should_not permit(:destroy) }
  end

  context 'for the sharer' do
    let(:user) { sharer }
    it { should permit(:show) }
    it { should permit(:update) }
    it { should permit(:destroy) }
  end

  context 'for an admin of the organisation' do
    let(:user) { organisation_admin }
    it { should permit(:show) }
    it { should permit(:update) }
    it { should_not permit(:destroy) }
  end

  context 'for a staff member of the organisation' do
    let(:user) { organisation_staff }
    it { should permit(:show) }
    it { should_not permit(:update) }
    it { should_not permit(:destroy) }
  end

  context 'for some rando' do
    let(:user) { FactoryBot.create(:user) }
    include_examples 'can not do anything'
  end

  context 'when the share is revoked' do
    let(:share) { FactoryBot.create(:share, :revoked, user: sharer, recipient: organisation) }
    context 'for an admin of the organisation' do
      let(:user) { organisation_admin }
      include_examples 'can not do anything'
    end
    context 'for a staff member of the organisation' do
      let(:user) { organisation_staff }
      include_examples 'can not do anything'
    end
    context 'for the sharer' do
      let(:user) { sharer }
      it { should permit(:show) }
      it { should permit(:update) }
      it { should permit(:destroy) }
    end
  end
end
