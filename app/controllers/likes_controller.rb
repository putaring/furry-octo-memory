class LikesController < ApplicationController
  before_action :authenticate!

  def likers
    @passive_interests = current_user.passive_interests.includes(:liker).reverse_ordered
  end

  def liked
    @active_interests = current_user.active_interests.includes(:liked).reverse_ordered
  end

  def mutual
    @mutual_interests = current_user.active_interests.includes(:liked).
      joins("inner join interests passive_interests on interests.liker_id = passive_interests.liked_id").
      where("passive_interests.liker_id = interests.liked_id").
      select("interests.*, greatest(passive_interests.created_at, interests.created_at) as matched_at").
      order('matched_at DESC')
  end

end
