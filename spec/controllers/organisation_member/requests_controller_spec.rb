# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganisationMember::RequestsController do
  let(:user) { FactoryBot.create :user }
  let(:organisation) { FactoryBot.create :organisation }
  let(:req) { FactoryBot.create(:request, requester: organisation) }

  before do
    user.add_role(organisation, 'staff')
    sign_in user
    FactoryBot.create_list(:request, 5) # create some other requests
    request
  end

  describe 'GET index' do
    before { get :index, params: { organisation_id: organisation.id } }
    it { expect(assigns(:requests)).to eq([req]) }
    it { expect(response).to render_template('index') }
  end
  describe 'GET show' do
    describe 'allows a user to see requests scoped to their organisation' do
      before { get :show, params: { organisation_id: organisation.id, id: req.id } }
      it { expect(response).to have_http_status(:ok) }
    end
    describe "does not allow a user to see requests that don't belong to that organisation" do
      let(:another_request) { FactoryBot.create(:request) }
      before { get :show, params: { organisation_id: organisation.id, id: another_request.id } }
      it { expect(response).to redirect_to root_path }
    end
  end
  describe 'GET new' do
    it 'creates a request with the organisation as the requester' do
      get :new, params: { organisation_id: organisation.id }
      expect(assigns(:request).requester).to eq(organisation)
    end
  end
  describe 'POST cancel' do
    subject { post(:cancel, params: { organisation_id: organisation.id, id: req.id }) }
    it 'assigns @request' do
      subject
      expect(assigns(:request)).to eq(req)
    end
    it 'checks permissions' do
      other_request = FactoryBot.create(:request)
      expect do
        post(:cancel, params: { organisation_id: organisation.id, id: other_request.id })
      end.not_to(change { other_request })
      expect(response).to redirect_to root_path
    end
    it 'renders the request show page' do
      expect(subject).to render_template('show')
    end
  end
end
