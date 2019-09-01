# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'user/AuditsController', type: :request do
  context 'A User' do
    let(:user) { FactoryBot.create(:user) }

    before do
      sign_in user
    end

    describe '#index' do
      context 'when the user has added a birth record' do
        let(:birth_record) { FactoryBot.create(:birth_record) }
        before do
          birth_record.add_to(user)
        end

        it 'the view shows an audit for it' do
          get user_audits_path

          expect(response).to be_successful
          expect(response.body)
            .to include("<strong>Add</strong> birth record of <strong>#{CGI.escapeHTML(birth_record.full_name)}")
        end

        context 'and they share it' do
          let(:organisation) { FactoryBot.create(:organisation) }

          before do
            birth_record.share_with(recipient: organisation, user: user)
          end

          it 'the view shows an audit for it' do
            get user_audits_path

            expect(response).to be_successful
            expect(response.body)
              .to include("<strong>Share</strong> birth record of <strong>#{CGI.escapeHTML(birth_record.full_name)}")
          end

          context 'then they revoke the share' do
            before do
              user.shares.last.revoke(revoked_by: user)
            end

            it 'the view shows an audit for it' do
              get user_audits_path

              expect(response).to be_successful
              expect(response.body)
                .to include(
                  "Revoke</strong> sharing of birth record of <strong>#{CGI.escapeHTML(birth_record.full_name)}"
                )
            end
          end
        end

        context 'then they remove the birth record' do
          before do
            birth_record.remove_from(user)
          end

          it 'the view shows an audit for it' do
            get user_audits_path

            expect(response).to be_successful
            expect(response.body)
              .to include("<strong>Remove</strong> birth record of <strong>#{CGI.escapeHTML(birth_record.full_name)}")
          end
        end
      end
    end
  end
end
