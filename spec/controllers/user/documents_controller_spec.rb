# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::DocumentsController do
  let(:user) { FactoryBot.create(:user) }
  before do
    sign_in user
  end

  describe 'show' do
    include_context 'document types' do
      it 'renders each document type' do
        one_of_each_document_type.each do |document|
          document.add_to(user)
          get(:show, params: { id: document.id, type: document.document_type })
          expect(response).to have_http_status(200)
        end
      end
    end
  end

  describe 'remove' do
    include_context 'document types' do
      it 'removes any document type' do
        one_of_each_document_type.each do |document|
          document.add_to(user)
          post(:remove, params: { id: document.id, type: document.document_type })
          expect(user.documents).not_to include(document)
          expect(response).to have_http_status(302) #redirected
        end
      end
    end
  end
end
