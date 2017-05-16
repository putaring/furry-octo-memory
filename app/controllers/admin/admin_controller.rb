class Admin::AdminController < ApplicationController
  layout 'admin'

  before_action :authorize_admin!

  private

  def authorize_admin!
    raise ActionController::RoutingError.new('Not Found') unless current_user && current_user.admin?
  end
end
