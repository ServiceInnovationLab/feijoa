# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Factory' do
    let(:user) { FactoryBot.create(:user) }
    let(:organisation) { FactoryBot.create(:organisation) }

    context 'user has the role' do
      before do
        OrganisationMember.create!(organisation: organisation, user: user, role: 'boss')
      end

      it 'states user role' do
        expect(user.role_for(organisation)).to eq('boss')
      end
    end

    context 'user has no roles' do
      it 'states user role' do
        expect(user.role_for(organisation)).to eq nil
      end
    end
    # user.admin_for?(organisation)
    # Should return false when a user isn't a member of the organisation
    # Should return false when a user has a role other than admin with the organisation
    # Should return true when a user is a member of the organisation and has the admin role

    # user.member_of?(organisation)
    # Should return false when a user isn't a member of the organisation
    # Should return true when a user is a member of the organisation
  end
end
