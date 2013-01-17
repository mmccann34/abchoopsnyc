class Game < ActiveRecord::Base
  attr_accessible :away_team_id, :home_team_id, :season_id
  validates :away_team_id, :home_team_id, :season_id, presence: true

  belongs_to :home_team, class_name: 'Team', foreign_key: 'home_team_id'
  belongs_to :away_team, class_name: 'Team', foreign_key: 'away_team_id'
  belongs_to :season

  has_many :stat_lines

  def team_stats(team_id)
    stat_lines.select {|s| s.team_id == team_id}
  end

  def create_stat_lines
    update_stat_lines(home_team)
    update_stat_lines(away_team)
  end

  private
  def update_stat_lines(team)
    team.players.each do |player|
      if !self.stat_lines.any? {|stat| stat.player_id == player.id }
        self.stat_lines << StatLine.create(team_id: team.id, player_id: player.id)
      end
    end
  end
end