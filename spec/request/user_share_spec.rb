# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'user/SharesController', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:share) { FactoryBot.create(:share, user: user) }
  before do
    share
    sign_in user
  end
  describe '#index' do
    it 'the index lists the share' do
      get user_shares_path

      expect(response).to be_successful
      expect(response.body).to include(share.birth_record.short_name)
    end
  end
  describe '#show' do
    it 'is displayed' do
      get user_share_path(share)

      expect(response).to be_successful
      expect(response.body).to include(share.birth_record.first_and_middle_names)
      expect(response.body).to include(share.birth_record.family_name)
    end
  end
  describe '#revoke' do
    it 'can be revoked by the user' do
      post revoke_user_share_path(share)
      expect(response).to be_redirect

      share.reload
      expect(share).to be_revoked
      expect(share.revoker).to eq(user)
    end
  end
end
