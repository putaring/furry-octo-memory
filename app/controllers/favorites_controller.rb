class FavoritesController < ApplicationController
  before_action :authenticate!

  def index
    @active_bookmarks = current_user.active_bookmarks.joins(:bookmarked).includes(:bookmarked).reverse_order
  end

end
