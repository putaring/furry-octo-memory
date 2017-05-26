require 'rails_helper'

RSpec.describe PhoneVerification, type: :model do
  context "validations" do
    subject(:phone_verification) { build(:phone_verification) }

    it { should validate_presence_of(:ip) }
    it { should validate_presence_of(:code) }
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:phone_number) }

    it { should validate_length_of(:code).is_equal_to(4) }

    it { should validate_numericality_of(:code).only_integer }

    it { should belong_to(:user) }

    it { should be_valid }
  end

end
