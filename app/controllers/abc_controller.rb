class AbcController < ApplicationController
  layout "abc"
  
  def show_boxscore
    render :boxscore
  end
end