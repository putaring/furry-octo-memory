class Bookmark < ActiveRecord::Base
  belongs_to :bookmarked, -> { where(account_status: User.account_statuses[:active]) }, class_name: "User"
  belongs_to :bookmarker, -> { where(account_status: User.account_statuses[:active]) }, class_name: "User"
end
