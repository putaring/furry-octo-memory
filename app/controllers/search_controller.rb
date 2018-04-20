class SearchController < ApplicationController

  def show
    search if params[:gender].present?
    respond_to do |format|
      format.html
    end
  end

  private

  def search
    @users = User.active.reverse_order.page params[:page]
    filter_gender if params[:gender].present?
    filter_status if params[:status].present?
    filter_age
    filter_height
    filter_religion if params[:religion].present?
    filter_languages if params[:languages].present?
    filter_countries if params[:countries].present?
  end

  def filter_gender
    @users = @users.where(gender: params[:gender])
  end

  def filter_status
    @users = @users.where(status: User.statuses[params[:status]])
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
    @users = @users.where(religion: User.religions[params[:religion]])
    if params[:religion].eql?('hindu') && params[:sects].present?
      sects = params[:sects].reject { |s| s.empty? }
      @users = @users.where(sect: sects) if sects.any?
    end
  end

  def filter_languages
    @users = @users.where(language: params[:languages])
  end

  def filter_countries
    @users = @users.where(country: params[:countries])
  end
end
