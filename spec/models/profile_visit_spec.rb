require 'rails_helper'

RSpec.describe ProfileVisit, type: :model do
  it { should belong_to(:visitor) }
  it { should belong_to(:visited) }
end
