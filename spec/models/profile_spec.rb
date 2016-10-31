require 'rails_helper'

RSpec.describe Profile, type: :model do
  context "validations" do
    it { should belong_to(:user) }
    it { should validate_length_of(:about).is_at_most(1500) }
    it { should allow_value(nil).for(:about) }
    it { should validate_length_of(:occupation).is_at_most(1500) }
    it { should allow_value(nil).for(:occupation) }
    it { should validate_length_of(:preference).is_at_most(1500) }
    it { should allow_value(nil).for(:preference) }
  end
end
