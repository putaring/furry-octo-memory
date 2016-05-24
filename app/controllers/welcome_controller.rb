class WelcomeController < ApplicationController
  layout "no_nav", only: [:index]
  def index
  end
end
