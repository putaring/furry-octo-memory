class PhotosController < ApplicationController
  before_action :authenticate!

  def index
    @photo  = Photo.new
    @photos = current_user.photos.ranked
  end

  def show
    photo = current_user.photos.find(params[:id])
    render json: photo, status: :ok
  end

  def create
    @photo = current_user.photos.build(photo_params)
    if @photo.save
      redirect_to photos_path, notice: "Your photo will be ready in a moment."
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

    respond_to do |format|
      if @photo && @photo.destroy
        format.html { redirect_to photos_path, notice: 'Deleted.' }
        format.js { head :no_content }
      else
        format.html { render 'index' }
        format.js { head :unprocessable_entity }
      end
    end
  end

  private

  def photo_params
    params.require(:photo).permit(:image).merge(ip: request.remote_ip)
  end

end
