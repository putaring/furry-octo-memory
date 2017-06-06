module SessionsHelper
  def current_user
    @_current_user ||= cookies.signed[:auth_token] &&
      User.find_by(id: cookies.signed[:auth_token])
  end

  def logged_in?
    current_user.present?
  end

  def logout
    cookies.delete(:auth_token)
    @_current_user = nil
  end

  def login(user)
    cookies.permanent.signed[:auth_token] = user.id
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  def authenticate!
    if current_user.nil?
      if request.xhr?
        head :unauthorized, location: login_path
      else
        store_location
        redirect_to login_path
      end
    end
  end

end
