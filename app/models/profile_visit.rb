class ProfileVisit < ActiveRecord::Base
  belongs_to :visited, -> { where(account_status: User.account_statuses[:active]) }, class_name: "User"
  belongs_to :visitor, -> { where(account_status: User.account_statuses[:active]) }, class_name: "User"
end
