class PhotosController < ApplicationController
  before_action :authenticate!

  def index
    @photos = current_user.photos
  end

  def create
    @photo        = current_user.photos.new(photo_params.except(:image))
    @photo.image  = photo_params[:image]

    if @photo.save
      redirect_to photos_path, notice: 'Added. You look fantastic.'
    else
      render 'index'
    end
  end

  def make_profile_photo
    @photo = current_user.photos.find(params[:id])
    if @photo && @photo.make_profile_photo
      redirect_to photos_path, notice: 'Profile photo changed.'
    else
      render 'index'
    end
  end

  def destroy
    @photo = current_user.photos.find(params[:id])
    if @photo && @photo.destroy
      redirect_to photos_path, notice: 'Deleted.'
    else
      render 'index'
    end
  end

  private

  def photo_params
    @_photo_params ||= params.require(:photo).permit(:image, :image_x, :image_y, :image_width)
  end

end
