class CareerHigh < ActiveRecord::Base
  attr_accessible :description, :game, :player_id, :value, :stat_type, :game_id
  
  belongs_to :player
end
