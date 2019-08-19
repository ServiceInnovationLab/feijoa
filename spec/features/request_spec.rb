# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sending a request from an organisation', type: :feature do
  context 'when a user is acting on behalf of an organisation' do
    it 'requires an email address for the requestee'
    it 'saves the current organisation as the requester'
  end
  context 'when the recipient has an existing account' do
    let(:recipient_email) { 'hello123@example.com' }
    let!(:recipient) { User.create(email: recipient_email) }

    it "shows a badge on the recipient's header bar when they log in"
    it "shows details of the request on the recipient's request page"
  end

  context 'when the recipient does not have an existing account' do
    let(:recipient_email) { 'hello123@example.com' }

    it 'invites the user'
    context 'after the user has created an account' do
      it "shows a badge on the recipient's header bar"
      it "shows details of the request on the recipient's request page"
    end
  end
end
