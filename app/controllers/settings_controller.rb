class SettingsController < ApplicationController
  before_action :authenticate!

  def about
    @profile = current_user.profile
  end
end
