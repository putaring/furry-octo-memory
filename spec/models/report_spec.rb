require 'rails_helper'

RSpec.describe Report, type: :model do
  context 'validations' do
    subject(:report) { build(:report) }

    it { should validate_presence_of(:reason) }
    it { should belong_to(:reporter) }
    it { should belong_to(:reported) }
  end

  describe ".unresolved" do
    it "returns the unresolved reports" do
      create_list(:report, 3)
      expect(Report.unresolved.count).to eq(3)
    end
  end

  describe ".resolved" do
    it "returns the resolved reports" do
      create_list(:resolved_report, 2)
      expect(Report.resolved.count).to eq(2)
    end
  end
end
