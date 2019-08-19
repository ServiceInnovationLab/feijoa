# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Factory' do
    let(:user) { FactoryBot.create(:user) }
    let(:organisation) { FactoryBot.create(:organisation) }
    let(:organisation1) { FactoryBot.create(:organisation) }

    context 'user has the role' do
      before do
        OrganisationMember.create!(organisation: organisation, user: user, role: 'boss')
      end
      it 'states user role' do
        expect(user.role_for(organisation)).to eq('boss')
      end
      it { expect(user.admin_for?(organisation)).to eq(false) }
      it { expect(user.member_of?(organisation)).to eq(true) }
      it { expect(user.member_of?(organisation1)).to eq(false) }
    end

    context 'user has no roles' do
      it 'states user role' do
        expect(user.role_for(organisation)).to eq nil
      end
      it { expect(user.admin_for?(organisation)).to eq(false) }
      it { expect(user.member_of?(organisation)).to eq(false) }
      it { expect(user.member_of?(organisation1)).to eq(false) }
    end

    context 'user is admin' do
      before do
        OrganisationMember.create!(organisation: organisation, user: user, role: OrganisationMember::ADMIN_ROLE)
      end
      it { expect(user.role_for(organisation)).to eq('admin') }
      it { expect(user.admin_for?(organisation)).to eq(true) }
      it { expect(user.member_of?(organisation)).to eq(true) }
      it { expect(user.member_of?(organisation1)).to eq(false) }
    end

    context 'user is member' do
      before do
        OrganisationMember.create!(organisation: organisation, user: user, role: 'member')
      end
      it { expect(user.member_of?(organisation)).to eq(true) }
      it { expect(user.member_of?(organisation1)).to eq(false) }
      it { expect(user.role_for(organisation)).to eq('member') }
    end
  end
end
