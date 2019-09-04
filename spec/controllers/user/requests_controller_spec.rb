# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::RequestsController do
  render_views

  let(:user) { FactoryBot.create(:user) }
  # can't call this `request` - namespace collision
  let!(:req) { FactoryBot.create(:request, requestee: user) }
  let!(:requests) { FactoryBot.create_list(:request, 5) }

  context 'anonymous' do
    describe 'GET index' do
      before { get :index }
      it { expect(response).to redirect_to new_user_session_path }
    end
    describe 'GET show' do
      before { get(:show, params: { id: req.id }) }
      it { expect(response).to redirect_to new_user_session_path }
    end
  end

  context 'signed in' do
    before { sign_in user }
    describe 'GET index' do
      before { get :index }
      it 'Can only see their request' do
        expect(assigns(:requests)).to eq([req])
      end
    end
    describe 'GET show' do
      describe 'their own request' do
        before { get(:show, params: { id: req.id }) }
        it { expect(assigns(:request)).to eq req }
        it { expect(response).to have_http_status(:ok) }
      end
      describe "asking for someone else's request" do
        it 'does not allow a user to see requests that are not theirs' do
          other_request = FactoryBot.create(:request)
          expect { get(:show, params: { id: other_request.id }) }.to raise_error(ActiveRecord::RecordNotFound)
        end
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
        expect { post(:decline, params: { id: other_request.id }) }.to raise_error(ActiveRecord::RecordNotFound)
      end
      it 'renders the request show page' do
        expect(subject).to render_template('show')
      end
    end
  end
end
