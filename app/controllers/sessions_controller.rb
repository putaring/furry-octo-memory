class SessionsController < ApplicationController
  before_action :redirect_if_logged_in!
  
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      login(user)
      redirect_to me_path
    else
      flash.now[:error] = 'Invalid email/password combination. Please try again.'
      render 'new'
    end
  end
end
