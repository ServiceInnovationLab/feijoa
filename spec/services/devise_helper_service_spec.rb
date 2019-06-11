# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeviseHelperService do
  describe '#model_root_path' do
    context 'for a User' do
      let(:resource) { FactoryBot.create(:user) }
      subject { DeviseHelperService.model_root_path(resource) }

      it 'returns /user' do
        expect(subject).to eq('/user') 
      end
    end

    context 'for an AdminUser' do
      let(:resource) { FactoryBot.create(:admin_user) }
      subject { DeviseHelperService.model_root_path(resource) }

      it 'returns /admin_user' do
        expect(subject).to eq('/admin_user') 
      end
    end

    context 'for an some unrecognised object' do
      let(:resource) { Object.new}
      subject { DeviseHelperService.model_root_path(resource) }

      it 'returns /' do
        expect(subject).to eq('/')
      end
    end
  end
end
