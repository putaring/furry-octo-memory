class Avatar < ActiveRecord::Base
  include AvatarUploader::Attachment.new(:image)
  belongs_to :user
end
