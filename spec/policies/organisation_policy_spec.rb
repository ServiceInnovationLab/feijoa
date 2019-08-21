# frozen_string_literal: true

require 'rails_helper'

describe OrganisationPolicy do
  subject { OrganisationPolicy.new(user, organisation) }

  let(:organisation) { FactoryBot.create(:organisation) }

  shared_examples 'not an organisation member' do
    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_action(:create) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:destroy) }
  end

  shared_examples 'an organisation member' do
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end

  context 'for a user with no organisation' do
    let(:user) { FactoryBot.create(:user) }

    include_examples 'not an organisation member'
  end

  context 'for a user with different organisation' do
    let(:user) { FactoryBot.create(:user) }

    include_examples 'not an organisation member'
  end

  context 'for a user with same organisation' do
    let(:user) { FactoryBot.create(:user) }
    let(:organisation) { FactoryBot.create(:organisation) }

    include_examples 'an organisation member'
  end
end
