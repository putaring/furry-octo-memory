class LikesController < ApplicationController
  before_action :authenticate!

  def show
    @active_interests = current_user.active_interests.joins(:liked).includes(:liked).reverse_order
  end

  def likers
    @passive_interests = current_user.passive_interests.joins(:liker).includes(:liker).reverse_order
  end

end
