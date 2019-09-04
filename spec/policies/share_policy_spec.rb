# frozen_string_literal: true

require 'rails_helper'

describe SharePolicy do
  subject { SharePolicy.new(user, share) }

  let(:organisation) { FactoryBot.create(:organisation) }
  let(:sharer) { FactoryBot.create(:user) }
  let(:user) { FactoryBot.create(:user) }
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
    before { user.add_role(organisation, 'admin') }
    it { should permit(:show) }
    it { should permit(:update) }
    it { should_not permit(:destroy) }
  end

  context 'for a staff member of the organisation' do
    before { user.add_role(organisation, 'staff') }
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
      before { user.add_role(organisation, 'admin') }
      include_examples 'can not do anything'
    end

    context 'for a staff member of the organisation' do
      before { user.add_role(organisation, 'staff') }
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
