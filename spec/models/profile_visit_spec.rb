require 'rails_helper'

RSpec.describe ProfileVisit, type: :model do
  it { is_expected.to belong_to(:visitor) }
  it { is_expected.to belong_to(:visited) }
end
