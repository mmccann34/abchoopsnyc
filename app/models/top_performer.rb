class TopPerformer < ActiveRecord::Base
  attr_accessible :name, :game_id, :player_id, :stat, :team, :performer_type

  belongs_to :game
end
