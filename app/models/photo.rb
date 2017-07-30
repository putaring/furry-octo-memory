class Photo < ActiveRecord::Base
  attr_accessor :image_x, :image_y, :image_width,
    :final_crop_x, :final_crop_y,
    :final_image_width, :original_image_width

  belongs_to :user

  scope :ranked, -> { order(:rank) }
  scope :visible, -> { where(status: [Photo.statuses[:active], Photo.statuses[:inactive]]) }
  mount_uploader :image, PhotoUploader

  validates_presence_of     :rank
  validates_numericality_of :rank, greater_than_or_equal_to: 1

  validate :valid_rank, on: :update, if: ->(p) { p.rank_changed? }

  before_validation :set_rank, on: :create, if: ->(p) { p.user.present? }
  before_update     :sort_photos, if: ->(p) { p.rank_changed? }
  before_destroy    :adjust_ranks

  enum status: { inactive: 0, active: 1, deleted: 2 }

  def make_profile_photo
    update_attributes(rank: 1)
  end

  def process_remote_picture(photo_details)
    update_attributes(photo_details.merge(status: Photo.statuses[:active]))
  end

  private

  def set_rank
    self.rank = self.user.photos.count + 1
  end

  def sort_photos
    if rank_was < rank
      user.photos.where('rank <= ? AND rank > ?', rank, rank_was).
        where('id != ?', id).
        each { |photo| photo.update_columns(rank: photo.rank - 1) }
    else
      user.photos.where('rank >= ? AND rank < ?', rank, rank_was).
        where('id != ?', id).
        each { |photo| photo.update_columns(rank: photo.rank + 1) }
    end
  end

  def adjust_ranks
    user.photos.where('rank > ?', rank).each { |photo| photo.decrement!(:rank) }
  end

  def valid_rank
    errors.add(:rank, 'cannot exceed photo count') if rank > user.photos.count
  end

end
