class InterestsController < ApplicationController
  before_action :authenticate!

  def index
    @active_interests = current_user.active_interests.joins(:liked).includes(:liked).reverse_order
  end

  def likers
    @passive_interests = current_user.passive_interests.joins(:liker).includes(:liker).reverse_order
  end

  def accept
    liker = current_user.passive_interests.find(params[:id]).liker
    if (interest = current_user.like(liker))
      Ses::AcceptEmailJob.perform_later(interest.id)
      render json: interest, status: :created
    else
      head :unprocessable_entity
    end
  end

  def decline
    liker = current_user.passive_interests.find(params[:id]).liker
    if current_user.decline(liker)
      Ses::DeclineEmailJob.perform_later(current_user.id, liker.id)
      head :no_content
    else
      head :unprocessable_entity
    end
  end

end
