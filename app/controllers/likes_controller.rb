class LikesController < ApplicationController
  before_action :authenticate!

  def likers
    @passive_interests = current_user.passive_interests.includes(:liker).reverse_ordered
  end
end
