class PhotosController < ApplicationController
  before_action :authenticate!
  before_action :set_s3_direct_post, only: [:index]

  def index
    @photos = current_user.photos
  end

  def show
    photo = current_user.photos.find(params[:id])
    render json: photo, status: :ok
  end

  def create
    @photo = current_user.photos.create

    if @photo.save
      ProcessPhotoJob.perform_later(@photo.id, photo_params.except(:image))
      redirect_to photos_path, notice: "Your photo will be ready in a bit."
    else
      render 'index'
    end
  end

  def make_profile_photo
    @photo = current_user.photos.find(params[:id])
    if @photo && @photo.make_profile_photo
      redirect_to photos_path, notice: 'Profile photo updated.'
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
    @_photo_params ||= params.require(:photo).permit(:image, :image_x, :image_y, :image_width, :remote_image_url)
  end

  def set_s3_direct_post
    @s3_direct_post = S3_BUCKET.presigned_post({
      key: "temp-uploads/#{Date.today}/#{SecureRandom.uuid}/${filename}",
      success_action_status: '201',
      acl: 'public-read'
    })
  end

end
