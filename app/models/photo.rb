class Photo < ActiveRecord::Base
  include PhotoUploader::Attachment.new(:image)
  belongs_to :user
end
