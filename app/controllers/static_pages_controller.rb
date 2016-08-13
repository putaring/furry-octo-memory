class StaticPagesController < ApplicationController
  before_action :redirect_if_logged_in!, only: :index
  def index
    @user = User.new
  end
end
