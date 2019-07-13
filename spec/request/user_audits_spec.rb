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
          AuditedOperationsService.add_birth_record_to_user(user: user, birth_record: birth_record)
        end

        it 'the view shows an audit for it' do
          get user_audits_path

          expect(response).to be_successful
          expect(response.body)
            .to include("<strong>Add</strong> birth record of <strong>#{CGI.escapeHTML(birth_record.full_name)}")
        end

        context 'and they share it' do
          let(:organisation_user) { FactoryBot.create(:organisation_user) }

          before do
            AuditedOperationsService.share_birth_record_with_recipient(
              user: user,
              birth_record: birth_record,
              recipient: organisation_user
            )
          end

          it 'the view shows an audit for it' do
            get user_audits_path

            expect(response).to be_successful
            expect(response.body)
              .to include("<strong>Share</strong> birth record of <strong>#{CGI.escapeHTML(birth_record.full_name)}")
          end

          context 'then they revoke the share' do
            before do
              AuditedOperationsService.revoke_share(user: user, share: user.shares.last)
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
            AuditedOperationsService.remove_birth_record_from_user(user: user, birth_record_id: birth_record.id)
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
