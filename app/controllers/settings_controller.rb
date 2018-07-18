class SettingsController < ApplicationController
  before_action :authenticate!

  def show
    redirect_to email_settings_path
  end

  def email
  end

  def privacy
  end

end
