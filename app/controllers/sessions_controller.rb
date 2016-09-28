class SessionsController < ApplicationController
  before_action :redirect_if_logged_in!, except: :destroy

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      login(user)
      if request.xhr?
        head :ok
      else
        redirect_to me_path
      end
    else
      if request.xhr?
        head :unauthorized
      else
        flash.now[:error] = 'Invalid email or password.'
        render 'new'
      end
    end
  end

  def destroy
    logout if logged_in?
    redirect_to root_url
  end
end
