require 'rails_helper'

RSpec.describe Profile, type: :model do
  context "validations" do
    it { should belong_to(:user) }
    it { should validate_length_of(:about).is_at_most(1500) }
  end
end
