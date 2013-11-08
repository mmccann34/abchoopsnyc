class Game < ActiveRecord::Base
  attr_accessible :away_team_id, :home_team_id, :season_id, :home_score_first, :home_score_second, :home_score_ot_one, :home_score_ot_two, :home_score_ot_three, 
  :away_score_first, :away_score_second, :away_score_ot_one, :away_score_ot_two, :away_score_ot_three, :date, :time, :location_id, :forfeit, :winner
  validates :away_team_id, :home_team_id, :season_id, presence: true

  belongs_to :home_team, class_name: 'Team', foreign_key: 'home_team_id'
  belongs_to :away_team, class_name: 'Team', foreign_key: 'away_team_id'
  belongs_to :winning_team, class_name: 'Team', foreign_key: 'winner'
  belongs_to :season
  belongs_to :location

  has_many :stat_lines, dependent: :destroy

  after_initialize :set_defaults

  before_save do
    set_defaults
    self.home_score = home_score_first + home_score_second + home_score_ot_one + home_score_ot_two + home_score_ot_three
    self.away_score = away_score_first + away_score_second + away_score_ot_one + away_score_ot_two + away_score_ot_three
    if !self.forfeit
      if self.home_score != 0 && self.away_score != 0
        self.winner = self.home_score > self.away_score ? self.home_team.try(:id) : self.away_team.try(:id)
      else
        self.winner = nil
      end
    end
    
    #Figure out league/division
    home_team_spot = self.home_team.team_spots.where(season_id: self.season_id).first
    away_team_spot = self.away_team.team_spots.where(season_id: self.season_id).first
    if home_team_spot && away_team_spot
      self.league_id = home_team_spot.league_id == away_team_spot.league_id ? home_team_spot.league_id : nil
      self.division_id = home_team_spot.division_id == away_team_spot.division_id ? home_team_spot.division_id : nil
    end
  end

  after_save(on: :create) do
    create_stat_lines
  end

  def set_defaults
    self.home_score ||= 0
    self.home_score_first ||= 0
    self.home_score_second ||= 0
    self.home_score_ot_one ||= 0
    self.home_score_ot_two ||= 0
    self.home_score_ot_three ||= 0
    self.away_score ||= 0
    self.away_score_first ||= 0
    self.away_score_second ||= 0
    self.away_score_ot_one ||= 0
    self.away_score_ot_two ||= 0
    self.away_score_ot_three ||= 0
  end

  def team_stats(team_id)
    stat_lines.where(team_id: team_id)
  end

  def create_stat_lines
    update_stat_lines(home_team)
    update_stat_lines(away_team)
  end
  
  def week
    DateRange.where('season_id = ? AND ? >= start_date AND ? <= end_date', self.season_id, self.date, self.date).first
  end
  
  def week_name
    self.week ? self.week.name : nil
  end
  
  def next_game
    surrounding_games "next"
  end
  
  def previous_game
    surrounding_games "previous"
  end
  
  def abbreviation
    "#{self.time.strftime("%l%p")}: #{self.home_team.abbreviation} vs #{self.away_team.abbreviation}"
  end

  private
  def surrounding_games(game)
    games = Game.where('Date(date) = ?', self.date.to_date).where(league_id: self.league_id, division_id: self.division_id).order(:time)
    curr_index = games.index(self)
    if game == "next"
      curr_index + 1 < games.length ? games[curr_index + 1] : nil
    else
      curr_index - 1 >= 0 ? games[curr_index - 1] : nil
    end
  end
    
  def update_stat_lines(team)
    team.roster(self.season_id).each do |roster_spot|
      player = roster_spot.player
      stat_line = self.stat_lines.where(player_id: player.id, team_id: team.id).first
      if !stat_line
        self.stat_lines << StatLine.create(team_id: team.id, player_id: player.id, jersey_number: roster_spot.jersey_number)
      else
        if !stat_line.jersey_number
          stat_line.update_attribute(:jersey_number, roster_spot.jersey_number)
        end
      end
    end
  end
end