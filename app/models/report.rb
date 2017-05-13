class Report < ActiveRecord::Base
  belongs_to :reported, class_name: "User"
  belongs_to :reporter, class_name: "User"
  validates_presence_of :reason

  enum reason: { inappropriate_photo: 1, fake_profile: 2, other: 100 }
end
