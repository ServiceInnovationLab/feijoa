# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganisationsController, type: :controller do
  let!(:organisation) { FactoryBot.create :organisation }

  shared_examples 'paginated list of organisations' do
    describe 'paginated list of organisations' do
      before { get :index }
      it { expect(response).to have_http_status(:ok) }
      it { expect(assigns(:organisations)).to eq [organisation] }
    end
  end

  context 'not logged in' do
    before { get :index }
    it { expect(response).to redirect_to new_user_session_path }
  end

  context 'as a user' do
    let(:user) { FactoryBot.create :user }
    before { sign_in user }
    include_examples 'paginated list of organisations'
  end

  context 'as an org user' do
    let(:user) { FactoryBot.create :user }
    before do
      user.add_role(organisation, 'admin')
      sign_in user
    end
    include_examples 'paginated list of organisations'
  end
end
