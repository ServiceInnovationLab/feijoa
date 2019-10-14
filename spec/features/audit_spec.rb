# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Auditing' do
  let(:user) { FactoryBot.create(:user, email: 'user@example.com') }
  let(:org_user) { FactoryBot.create :user }
  let!(:organisation) { FactoryBot.create(:organisation, name: 'Example Org') }
  let!(:birth_records) { FactoryBot.create_list(:birth_record, 10) }
  before do
    org_user.add_role(organisation, 'staff')
  end

  include_context 'signed in' do
    context 'finds a birth record' do
      let(:target_record) { birth_records.sample }

      before do
        visit find_user_birth_records_path

        fill_in 'birth_record_first_and_middle_names', with: target_record.first_and_middle_names
        fill_in 'birth_record_family_name', with: target_record.family_name
        fill_in 'birth_record_date_of_birth', with: target_record.date_of_birth

        click_on 'Find'
      end

      context 'they add the birth record to their documents' do
        before do
          click_on 'Add'
        end

        it 'shows an "added..." audit message' do
          visit user_audits_path
          expect(page).to have_text("Add birth record of #{target_record.full_name}")
        end

        context 'they remove the birth record' do
          before do
            click_on 'View'
            page.accept_alert 'Are you sure? This will remove the record from your documents' do
              click_on 'Remove'
            end
          end

          it 'shows a "removed..." audit message' do
            visit user_audits_path
            expect(page).to have_text("Remove birth record of #{target_record.full_name}")
          end
        end

        context 'they share a birth record with an organisation' do
          let!(:organisation) { FactoryBot.create :organisation, name: 'Mangakino Kohanga Reo' }
          before do
            click_on 'Share'
            page.execute_script("$('#org-query').val('Mangakino');")
            # Can't get javascript to run, so fill in hidden field
            page.execute_script("document.getElementById('recipient_id').value = '#{organisation.id}'")
            click_on id: 'share-button'
          end

          it 'shows a "shared..." audit message' do
            visit user_audits_path
            expect(page).to have_text("Share birth record of #{target_record.full_name}")
            expect(page).to have_text("with #{organisation.name}")
          end

          context 'the organisation views the share' do
            before do
              sign_out user
              sign_in org_user

              visit organisation_member_shares_path(organisation)

              click_on 'Show'
              sleep(0.5) # to wait for audit to go through...
              sign_out org_user
            end

            it 'shows a "viewed..." audit message on org users account' do
              sign_in org_user
              visit user_audits_path
              expect(page).to have_text("View birth record of #{target_record.full_name}")
            end
            it 'shows a "viewed by" on birth record page' do
              sign_in user
              visit user_birth_record_path(target_record)
              expect(page).to have_text 'Viewed on '
              expect(page).to have_text " by #{org_user.email}"
            end
          end

          context 'they revoke the share' do
            before do
              page.accept_alert 'Are you sure?' do
                click_on 'Revoke'
              end
            end

            it 'shows a "revoked..." audit message' do
              visit user_audits_path
              expect(page).to have_text("Revoke access to birth record of #{target_record.full_name}")
              expect(page).to have_text("from #{organisation.name}")
            end
          end
        end
      end
    end
  end
end
