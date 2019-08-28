# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganisationMember::RequestsController do
  let(:organisation_member) { FactoryBot.create(:organisation_member) }
  let(:user) { organisation_member.user }
  let(:organisation) { organisation_member.organisation }
  let(:req) { FactoryBot.create(:request, requester: organisation) }

  before do
    sign_in user
    FactoryBot.create_list(:request, 5) # create some other requests
    request
  end

  describe 'GET index' do
    it 'assigns @requests' do
      get :index, params: { organisation_id: organisation.id }
      expect(assigns(:requests)).to eq([req])
    end
    it 'renders the index template' do
      get :index, params: { organisation_id: organisation.id }
      expect(response).to render_template('index')
    end
  end
  describe 'GET show' do
    it 'allows a user to see requests scoped to their organisation' do
      get :show, params: { organisation_id: organisation.id, id: req.id }
      expect(response).to have_http_status(200)
    end
    it "does not allow a user to see requests that don't belong to that organisation" do
      another_request = FactoryBot.create(:request)
      expect do
        get :show, params: { organisation_id: organisation.id, id: another_request.id }
      end.to raise_error(ActiveRecord::RecordNotFound)
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
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
    it 'renders the request show page' do
      expect(subject).to render_template('show')
    end
  end
end
