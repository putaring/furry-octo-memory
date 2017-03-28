require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  it { should belong_to(:bookmarker) }
  it { should belong_to(:bookmarked) }
end
