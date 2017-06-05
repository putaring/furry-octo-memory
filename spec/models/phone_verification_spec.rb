require 'rails_helper'

RSpec.describe PhoneVerification, type: :model do
  context "validations" do
    subject(:phone_verification) { create(:phone_verification) }

    it { should validate_presence_of(:ip) }
    it { should validate_presence_of(:code) }
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:phone_number) }

    it { should validate_length_of(:code).is_equal_to(4) }

    it { should validate_numericality_of(:code).only_integer }

    it { should belong_to(:user) }

    it { should be_valid }

    it "should not allow a validated number to be validated again" do
      create(:verified_number, phone_number: "+12134000000")
      duplicate_number  = build(:phone_verification, phone_number: "+12134000000")

      expect(duplicate_number).to be_invalid
    end
  end

  describe "#verify!" do
    let(:user) { create(:user) }
    let(:phone_verification) { create(:phone_verification, user: user) }

    before { phone_verification.verify! }

    it "should flag the record as verified" do
      expect(phone_verification.verified).to be true
    end

    it "should flag the user as verified" do
      expect(phone_verification.user.active?).to be true
    end
  end

end
