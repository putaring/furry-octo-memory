class SearchController < ApplicationController

  def show
    respond_to do |format|
      format.html
      format.js { render json: search }
    end
  end

  private

  def search
    @users = User.includes(:photos).where(gender: params[:gender])

    minimum_age, maximum_age = filter_age
    users = users.where("birthdate <= ?", minimum_age.years.ago.to_date) if minimum_age >= 18
    users = users.where("birthdate > ?", (maximum_age + 1).years.ago.to_date) if maximum_age >= 18

    minimum_height, maximum_height = filter_height
    users = users.where("height >= ?", minimum_height) if minimum_height > 0
    users = users.where("height <= ?", maximum_height) if maximum_height > 0

    users = users.where(religion: User.religions[params[:religion]]) if params[:religion].present?
    users = users.where(language: params[:languages]) if params[:languages].present?
    users = users.where(country: params[:countries]) if params[:countries].present?

    users.map do |user|
      {
        id: user.id, username: user.username, age: user.age, picture: user.display_thumbnail,
        country: user.country_name, religion: user.religion.humanize, gender: user.gender, visibility: user.photo_visibility
      }
    end
  end

  def filter_age
    if params[:min_age].present? && params[:max_age].present?
      [params[:min_age].to_i, params[:max_age].to_i].sort
    elsif params[:min_age].present?
      [params[:min_age].to_i, 0]
    elsif params[:max_age].present?
      [0, params[:max_age].to_i]
    else
      [0, 0]
    end
  end

  def filter_height
    if params[:min_height].present? && params[:max_height].present?
      [params[:min_height].to_i, params[:max_height].to_i].sort
    elsif params[:min_age].present?
      [params[:min_height].to_i, 0]
    elsif params[:max_age].present?
      [0, params[:max_height].to_i]
    else
      [0, 0]
    end
  end
end
