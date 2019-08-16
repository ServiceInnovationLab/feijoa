# frozen_string_literal: true

module FeatureHelpers
  shared_context 'signed in' do
    before { sign_in user }
    after { sign_out user }
  end
end

RSpec.configure do |config|
  config.include FeatureHelpers, type: :feature
end
