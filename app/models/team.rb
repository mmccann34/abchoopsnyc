class Team < ActiveRecord::Base
  attr_accessible :name
  validates :name, presence: true

  has_many :home_games, class_name: 'Game', foreign_key: 'home_team_id'
  has_many :away_games, class_name: 'Game', foreign_key: 'away_team_id'

  has_many :roster_entries, class_name: 'Roster', dependent: :destroy

  has_many :current_roster_entries, class_name: 'Roster', conditions: { season_id: Season.current_season.try(:id) }, dependent: :destroy
  has_many :players, through: :current_roster_entries, class_name: 'Player' , source: :player
end