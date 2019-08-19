# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganisationMember::DashboardController do
  describe 'GET index' do
    it 'shows a dashboard for an organisation the user is part of'
    it "doesn't show a dashboard for an organisation the user isn't part of"
  end
end
