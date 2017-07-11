module GtmHelper
  def data_layer
    dataLayer = [];
    dataLayer << { userId: "#{current_user.id}" } if logged_in?
    dataLayer << { profileId: "#{@user.id}"} if params[:controller] == "users" && params[:action] == "show"
    dataLayer
  end
end
