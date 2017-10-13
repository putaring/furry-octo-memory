require 'rails_helper'

RSpec.describe Profile, type: :model do
  context "validations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to validate_length_of(:about).is_at_most(1500) }
    it { is_expected.to allow_value(nil).for(:about) }
    it { is_expected.to validate_length_of(:occupation).is_at_most(1500) }
    it { is_expected.to allow_value(nil).for(:occupation) }
    it { is_expected.to validate_length_of(:preference).is_at_most(1500) }
    it { is_expected.to allow_value(nil).for(:preference) }
  end
end
