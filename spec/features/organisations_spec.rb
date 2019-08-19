# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organisations page', type: :feature do
  let!(:orgs) { FactoryBot.create_list :organisation, 5 }

  before do
    visit '/organisations'
  end

  describe 'displays table heading' do
    it { expect(page).to have_text('Organisations') }
  end

  describe 'displays a table of organisations' do
    it { expect(page).to have_css('.table.table-hover') }
    it { expect(page).to have_text('Name') }
    it { expect(page).to have_text('Address') }
    it { expect(page).to have_text('Email') }
    it { expect(page).to have_text('Contact No.') }
    it { expect(page).to have_text('List of organisations') }
  end

  describe 'displays an organisation' do
    it { expect(page).to have_content(orgs.first.name) }
    it { expect(page).to have_content(orgs.last.name) }
    it { expect(page).to have_content(orgs.first.address) }
    it { expect(page).to have_content(orgs.last.address) }
    it { expect(page).to have_content(orgs.first.email) }
    it { expect(page).to have_content(orgs.last.email) }
    it { expect(page).to have_content(orgs.first.contact_number) }
    it { expect(page).to have_content(orgs.last.contact_number) }
  end
end
