require 'rails_helper'

RSpec.describe Avatar, type: :model do
  context "validations" do
    it { is_expected.to belong_to(:user) }
  end
end
