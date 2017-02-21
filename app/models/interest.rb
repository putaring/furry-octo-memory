class Interest < ActiveRecord::Base
  belongs_to :liked, -> { where(account_status: User.account_statuses[:active]) }, class_name: "User"
  belongs_to :liker, -> { where(account_status: User.account_statuses[:active]) }, class_name: "User"
end
