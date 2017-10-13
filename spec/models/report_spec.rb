require 'rails_helper'

RSpec.describe Report, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:reason) }
    it { is_expected.to belong_to(:reporter) }
    it { is_expected.to belong_to(:reported) }
  end

  describe ".unresolved" do
    specify { expect { create_list(:report, 3) }.to change { Report.unresolved.count }.by(3) }
  end

  describe ".resolved" do
    specify { expect { create_list(:resolved_report, 3) }.to change { Report.resolved.count }.by(3) }
  end
end
