# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#action_in_bem_format' do
    context 'the controller is in the root namespace' do
      before do
        expect(helper)
          .to(receive(:params))
          .at_least(:once)
          .and_return('controller' => 'application', 'action' => 'index')
      end

      it 'formats the controller as E and the action as M ' do
        expect(helper.action_in_bem_format).to eq('application--index')
      end
    end

    context 'the controller is in a deep namespace' do
      before do
        expect(helper)
          .to(receive(:params))
          .at_least(:once)
          .and_return('controller' => 'food/desserts/nom', 'action' => 'nom-nom')
      end

      it 'formats the namespace as B, the controller as E, and the action as M' do
        expect(helper.action_in_bem_format).to eq('food-desserts__nom--nom-nom')
      end
    end
  end
end
