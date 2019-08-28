# frozen_string_literal: true

require 'rails_helper'

describe OrganisationPolicy do
  subject { OrganisationPolicy.new(user, organisation) }

  let(:organisation) { FactoryBot.create(:organisation) }

  shared_examples 'can only see organisations' do
    it { should permit(:show) }
    it { should permit(:index) }
    it { should_not permit(:create) }
    it { should_not permit(:update) }
    it { should_not permit(:destroy) }
  end

  context 'for a user with no organisation' do
    let(:user) { FactoryBot.create(:user) }

    include_examples 'can only see organisations'
  end

  context 'for a user with same organisation' do
    let(:user) { FactoryBot.create(:user) }
    before do
      # Adding a user to the organisation
      OrganisationMember.create!(organisation: organisation, user: user, role: 'boss')
    end

    include_examples 'can only see organisations'
  end

  context 'for a user with different organisation' do
    let(:user) { FactoryBot.create(:user) }
    let(:other_organisation) { FactoryBot.create(:organisation) }
    before do
      # Adding a user to a different organisation
      OrganisationMember.create!(organisation: other_organisation, user: user, role: 'boss')
    end

    include_examples 'can only see organisations'
  end
end
