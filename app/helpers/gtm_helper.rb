module GtmHelper
  def data_layer
    dataLayer = [];
    dataLayer << { userId: "#{current_user.id}" } if logged_in?
    dataLayer
  end
end
