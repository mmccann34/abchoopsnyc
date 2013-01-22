class Game < ActiveRecord::Base
  attr_accessible :away_team_id, :home_team_id, :season_id, :home_score_first, :home_score_second, :away_score_first, :away_score_second, :date, :time
  validates :away_team_id, :home_team_id, :season_id, presence: true

  belongs_to :home_team, class_name: 'Team', foreign_key: 'home_team_id'
  belongs_to :away_team, class_name: 'Team', foreign_key: 'away_team_id'
  belongs_to :season

  has_many :stat_lines, dependent: :destroy

  after_initialize :set_defaults

  before_save do
    set_defaults
    home_score = home_score_first + home_score_second
    away_score = away_score_first + away_score_second
  end

  after_save(on: :create) do
    create_stat_lines
  end

  def set_defaults
    self.home_score ||= 0
    self.home_score_first ||= 0
    self.home_score_second ||= 0
    self.away_score ||= 0
    self.away_score_first ||= 0
    self.away_score_second ||= 0
  end

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
      if !self.stat_lines.any? {|stat| stat.player_id == player.id and stat.team_id == team.id }
        self.stat_lines << StatLine.create(team_id: team.id, player_id: player.id)
      end
    end
  end
end