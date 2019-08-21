# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::RequestsController do
  render_views

  let(:user) { FactoryBot.create(:user) }
  let(:req) { FactoryBot.create(:request, requestee: user) } # can't call this `request` - namespace collision
  before do
    sign_in user
    FactoryBot.create_list(:request, 5) # create some other requests
    req
  end
  describe 'GET index' do
    it 'assigns @requests' do
      get :index
      expect(assigns(:requests)).to eq([req])
    end
    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end
  end
  describe 'GET show' do
    it 'allows a user to see their own requests' do
      get(:show, params: { id: req.id })
      expect(response).to have_http_status(200)
    end
    it 'does not allow a user to see requests that are not theirs' do
      other_request = FactoryBot.create(:request)
      expect { get(:show, params: { id: other_request.id }) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
  describe 'POST decline' do
    subject { post(:decline, params: { id: req.id }) }
    it 'assigns @request' do
      subject
      expect(assigns(:request)).to eq(req)
    end
    it 'checks permissions' do
      other_request = FactoryBot.create(:request)
      expect{ post(:decline, params: { id: other_request.id }) }.to raise_error(ActiveRecord::RecordNotFound)
    end
    it 'renders the request show page' do
      expect(subject).to render_template('show')
    end
  end
end
