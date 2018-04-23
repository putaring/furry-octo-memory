class PhotosController < ApplicationController
  before_action :authenticate!

  def index
    @photo  = Photo.new
    @photos = current_user.photos.reverse_order
  end

  def show
    photo = current_user.photos.find(params[:id])
    render json: photo, status: :ok
  end

  def create
    @photo = current_user.photos.build(photo_creation_params)
    if @photo.save
      redirect_to photos_path, notice: successful_upload_notice
    else
      render 'index'
    end
  end

  def update
    photo = current_user.photos.find(params[:id])
    if photo.update_attributes(photo_edit_params)
      redirect_to photos_path anchor: "photo-image-#{photo.id}"
    else
      redirect_to photos_path, notice: 'Oops. Something went wrong. Try again'
    end
  end

  def destroy
    @photo = current_user.photos.find(params[:id])

    respond_to do |format|
      if @photo && @photo.destroy
        format.html { redirect_to photos_path, notice: 'Deleted.' }
      else
        format.html { redirect_to photos_path, notice: "Couldn't delete photo. Try again." }
      end
    end
  end

  private

  def successful_upload_notice
    photo_count = current_user.photos.count
    remaining   = 10 - photo_count
    if  photo_count > 1
      "Added."
    else
      "All set! Add a caption to give potential matches a little more context."
    end
  end

  def photo_creation_params
    params
      .require(:photo)
      .permit(:image)
      .merge(ip: request.remote_ip)
  end

  def photo_edit_params
    params
      .require(:photo)
      .permit(:caption)
  end

end
