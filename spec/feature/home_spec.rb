# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/', type: :feature do
  it 'shows a fancy fruit' do
    visit root_path
    expect(page).to have_text('Feijoa')
    Percy.snapshot(page, name: 'homepage')
  end
end
