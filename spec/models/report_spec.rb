require 'rails_helper'

RSpec.describe Report, type: :model do
  context 'validations' do
    subject(:report) { build(:report) }

    it { should validate_presence_of(:reason) }
    it { should belong_to(:reporter) }
    it { should belong_to(:reported) }
  end

end
