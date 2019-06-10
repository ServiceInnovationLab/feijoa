# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/', type: :feature do
  it 'shows a fancy fruit' do
    visit '/'
    expect(page).to have_css('img#feijoas')
    Percy.snapshot(page)
  end
end
