class LikesController < ApplicationController
  before_action :authenticate!

  def likers
    @passive_interests = current_user.passive_interests.joins(:liker).includes(:liker).reverse_order
  end

  def liked
    @active_interests = current_user.active_interests.joins(:liked).includes(:liked).reverse_order
  end

  def mutual
    @mutual_interests = current_user.active_interests.includes(:liked).
      joins("inner join interests passive_interests on interests.liker_id = passive_interests.liked_id").
      joins("inner join users active_likes on passive_interests.liker_id = active_likes.id").
      where("active_likes.account_status = ?", User.account_statuses[:active]).
      where("passive_interests.liker_id = interests.liked_id").
      select("interests.*, greatest(passive_interests.created_at, interests.created_at) as matched_at").
      order('matched_at DESC')
  end

end
