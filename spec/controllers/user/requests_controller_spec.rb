# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::RequestsController do
  describe 'GET index' do
    it 'assigns @requests'
    it 'renders the index template'
  end
  describe 'GET show' do
    it 'allows a user to see their own requests'
    it 'does not allow a user to see requests that are not theirs'
  end
end
