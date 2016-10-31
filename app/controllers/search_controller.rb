class SearchController < ApplicationController

  def show
    respond_to do |format|
      format.html
      format.js { render json: search }
    end
  end

  private

  def search
    @users = User.includes(:photos)
    filter_gender
    filter_status
    filter_age
    filter_height
    filter_religion
    filter_languages
    filter_countries

    @users.map do |user|
      {
        id: user.id, username: user.username, age: user.age, picture: user.display_thumbnail,
        country: user.country_name, religion: user.religion.humanize, gender: user.gender, visibility: user.photo_visibility
      }
    end
  end

  def filter_gender
    @users = @users.where(gender: params[:gender]) if params[:gender].present?
  end

  def filter_status
    @users = @users.where(status: User.statuses[params[:status]]) if params[:status].present?
  end

  def filter_age
    minimum_age, maximum_age = [(params[:min_age].presence || 0).to_i, (params[:max_age].presence || 0).to_i]
    @users = @users.where("birthdate <= ?", minimum_age.years.ago.to_date) if minimum_age >= 18
    @users = @users.where("birthdate > ?", (maximum_age + 1).years.ago.to_date) if maximum_age >= 18
  end

  def filter_height
    minimum_height, maximum_height = [(params[:min_height].presence || 0).to_i, (params[:max_height].presence || 0).to_i]
    @users = @users.where("height >= ?", minimum_height) if minimum_height > 0
    @users = @users.where("height <= ?", maximum_height) if maximum_height > 0
  end

  def filter_religion
    @users = @users.where(religion: User.religions[params[:religion]]) if params[:religion].present?
    if params[:religion].eql?('hindu') && params[:sects].present?
      sects = params[:sects].reject { |s| s.empty? }
      @users = @users.where(sect: sects) if sects.any?
    end
  end

  def filter_languages
    @users = @users.where(language: params[:languages]) if params[:languages].present?
  end

  def filter_countries
    @users = @users.where(country: params[:countries]) if params[:countries].present?
  end
end
