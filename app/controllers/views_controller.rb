class TeamsController < ApplicationController
  before_filter: initialize
  
  def initialize:
    @use_abc_css = true
  end
end