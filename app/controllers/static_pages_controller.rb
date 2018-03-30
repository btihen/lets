class StaticPagesController < ApplicationController

  before_action :authenticate_admin!, except: [:home]

  def home
  end
  
end
