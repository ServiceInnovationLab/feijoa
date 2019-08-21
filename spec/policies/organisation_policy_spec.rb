# frozen_string_literal: true

require 'rails_helper'

describe OrganisationPolicy do
  subject { OrganisationPolicy.new(user, organisation) }

  shared_examples 'not an organisation member' do
    it { is_expected.not_to permit(:show)    }
    it { is_expected.not_to permit(:create)  }
    it { is_expected.not_to permit(:new)     }
    it { is_expected.not_to permit(:update)  }
    it { is_expected.not_to permit(:edit)    }
    it { is_expected.not_to permit(:destroy) }
  end

  shared_examples 'an organisation member' do
    let(:organisations) { FactoryBot.create(:organisations, organisation_ids: 1) }
    it { is_expected.to permit(:show)    }
    it { is_expected.to permit(:create)  }
    it { is_expected.to permit(:new)     }
    it { is_expected.to permit(:update)  }
    it { is_expected.to permit(:edit)    }
    it { is_expected.to permit(:destroy) }
  end

  context 'for a user with no organisation' do
    let(:user) { FactoryBot.create(:user) }

    include_examples 'not an organisation member'
  end

  context 'for a user with different organisation' do
    let(:user) { FactoryBot.create(:user, organisation_ids: 2) }

    include_examples 'not an organisation member'
  end

  context 'for a user with same organisation' do
    let(:user) { FactoryBot.create(:user, organisation_ids: 1) }

    include_examples 'an organisation member'
  end

end
