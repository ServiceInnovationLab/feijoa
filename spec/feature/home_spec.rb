# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/', type: :feature do
  it 'shows a fancy fruit' do
    visit '/'
    expect(page).to have_text('Feijoas')
    Percy.snapshot(page, name: 'homepage')
  end
end
