class TopPerformer < ActiveRecord::Base
  attr_accessible :name, :game_id, :player_id, :stat, :team_id, :performer_type

  belongs_to :game
  belongs_to :team
end
