class Profile < ActiveRecord::Base
  belongs_to :user
  validates_length_of :about, :occupation, :preference, maximum: 1500, allow_nil: true
  validates_uniqueness_of :user
end
