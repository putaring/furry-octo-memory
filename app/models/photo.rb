class Photo < ActiveRecord::Base
  attr_accessor :image_x, :image_y, :image_width

  default_scope { order(:rank) }

  belongs_to :user

  mount_uploader :image, PhotoUploader

  validates_presence_of     :rank, :image
  validates_numericality_of :rank, greater_than_or_equal_to: 1

  validate :valid_rank, on: :update, if: ->(p) { p.rank_changed? }

  before_validation :set_rank, on: :create, if: ->(p) { p.user.present? }
  before_update     :sort_photos, if: ->(p) { p.rank_changed? }
  before_destroy    :adjust_ranks, :remove_photo_files

  def make_profile_photo
    update_attributes(rank: 1)
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

  def remove_photo_files
    self.remove_image!
  end

end
