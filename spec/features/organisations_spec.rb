# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organisations page', type: :feature do
  before do
    visit '/organisations'
  end

  it 'displays table heading' do
    expect(page).to have_text('Organisations')
  end

  it 'displays a table of organisations' do
    expect(page).to have_css('.table.table-hover')
    expect(page).to have_text('Name')
    expect(page).to have_text('Address')
    expect(page).to have_text('Email')
    expect(page).to have_text('Contact No.')
    expect(page).to have_text('List of organisations')
  end
end
