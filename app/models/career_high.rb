class CareerHigh < ActiveRecord::Base
  attr_accessible :description, :game, :player_id, :value, :stat_type
  
  belongs_to :player
end
