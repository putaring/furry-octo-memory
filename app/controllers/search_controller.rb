class SearchController < ApplicationController

  def show
    respond_to do |format|
      format.html
      format.js { render json: search }
    end
  end

  private

  def search
    users = User.includes(:photos)

    users = users.where(gender: params[:gender])

    minimum_age, maximum_age = [params[:min_age].to_i, params[:max_age].to_i].sort
    users = users.where("birthdate <= ?", minimum_age.years.ago.to_date) if minimum_age >= 18
    users = users.where("birthdate >= ?", maximum_age.years.ago.to_date) if maximum_age >= 18

    minimum_height, maximum_height = [params[:min_height].to_i, params[:max_height].to_i].sort
    users = users.where("height >= ?", minimum_height) if minimum_height > 0
    users = users.where("height <= ?", maximum_height) if maximum_height > 0

    users = users.where(religion: params[:religion]) if params[:religion].present?
    users = users.where(language: params[:languages]) if params[:languages].present?
    users = users.where(country: params[:countries]) if params[:countries].present?
    users
  end

end
