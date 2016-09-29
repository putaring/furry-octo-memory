class Interest < ActiveRecord::Base
  belongs_to :liked, class_name: "User"
  belongs_to :liker, class_name: "User"

  scope :reverse_ordered,  -> { order('id DESC') }
end
