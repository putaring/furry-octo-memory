class Profile < ActiveRecord::Base
  belongs_to :user

  validates_length_of :about, maximum: 1500, allow_nil: true
end
