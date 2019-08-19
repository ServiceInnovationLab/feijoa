# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganisationMember::RequestsController do
  describe 'GET index' do
    it 'assigns @requests'
    it 'renders the index template'
  end
  describe 'GET show' do
    it 'allows a user to see requests scoped to their organisation'
    it "does not allow a user to see requests that don't belong to that organisation"
    it "does not allow a user who doesn't belong to that organisation to see those requests"
  end
end
