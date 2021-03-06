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

  describe 'User#find_or_invite' do
    context 'when passed an email associated with a user' do
      let(:user) { FactoryBot.create(:user) }
      it 'returns that user' do
        expect(User.find_or_invite(user.email)).to eq(user)
      end
      it 'does not invite that user' do
        expect { User.find_or_invite(user.email) }.not_to change(ActionMailer::Base.deliveries, :count)
      end
    end
    context 'when passed an email address not associated with a user' do
      it 'invites that email address' do
        expect { User.find_or_invite(Faker::Internet.email) }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
      it 'returns the new User object' do
        expect(User.find_or_invite(Faker::Internet.email)).to be_a(User)
      end
    end
  end

  describe 'user#documents' do
    let(:user) { FactoryBot.create(:user) }
    let(:birth_record) { FactoryBot.create(:birth_record) }
    let(:immunisation_record) { FactoryBot.create(:immunisation_record) }
    before do
      birth_record.add_to(user)
      immunisation_record.add_to(user)
    end
    it 'returns birth records and immunisation records by default' do
      expect(user.documents).to match_array([birth_record, immunisation_record])
    end
    it 'returns birth records when passed BirthRecord as a document type' do
      expect(user.documents(type: 'BirthRecord')).to eq([birth_record])
    end
    it 'returns immunisation records when passed ImmunisationRecord as a document type' do
      expect(user.documents(type: 'ImmunisationRecord')).to eq([immunisation_record])
    end
    it 'returns an empty array when passed any other document type' do
      expect(user.documents(type: 'passport')).to eq([])
    end
  end
end
