class Game < ActiveRecord::Base
  attr_accessible :away_team_id, :home_team_id, :season_id, :home_score_first, :home_score_second, :home_score_ot_one, :home_score_ot_two, :home_score_ot_three, 
  :away_score_first, :away_score_second, :away_score_ot_one, :away_score_ot_two, :away_score_ot_three, :date, :time, :location_id, :forfeit, :winner, :league_id,
  :playoff_round
  serialize :photo_urls
  validates :away_team_id, :home_team_id, :season_id, presence: true

  belongs_to :home_team, class_name: 'Team', foreign_key: 'home_team_id'
  belongs_to :away_team, class_name: 'Team', foreign_key: 'away_team_id'
  belongs_to :winning_team, class_name: 'Team', foreign_key: 'winner'
  belongs_to :season
  belongs_to :location
  belongs_to :league

  has_many :stat_lines, dependent: :destroy

  after_initialize :set_defaults

  before_save do
    set_defaults
    self.home_score = home_score_first + home_score_second + home_score_ot_one + home_score_ot_two + home_score_ot_three
    self.away_score = away_score_first + away_score_second + away_score_ot_one + away_score_ot_two + away_score_ot_three
    if !self.forfeit
      if self.home_score != 0 && self.away_score != 0
        if self.home_score == self.away_score
          self.winner = -1
        else
          self.winner = self.home_score > self.away_score ? self.home_team.try(:id) : self.away_team.try(:id)
        end
      else
        self.winner = nil
      end
    end
    
    if !self.new_record? && (self.home_team_id_changed? || self.away_team_id_changed?)
      self.stat_lines.where('team_id not in (?)', [home_team_id, away_team_id]).destroy_all
    end
      
    
    #Figure out league/division
    #home_team_spot = self.home_team.team_spots.where(season_id: self.season_id).first
    #away_team_spot = self.away_team.team_spots.where(season_id: self.season_id).first
    #if home_team_spot && away_team_spot
    #  self.league_id = home_team_spot.league_id == away_team_spot.league_id ? home_team_spot.league_id : nil
    #  self.division_id = home_team_spot.division_id == away_team_spot.division_id ? home_team_spot.division_id : nil
    #end
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
    DateRange.where('season_id = ? AND league_id = ? AND ? >= start_date AND ? <= end_date', self.season_id, self.league_id, self.date, self.date).first
  end
  
  def week_name
    self.week ? self.week.name : nil
  end
  
  def short_week_name
    self.week ? self.week.short_name : nil
  end
  
  def boxscore_week_name
    self.playoff_round.blank? ? self.week_name : self.playoff_round
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

  def top_scorer
    top_points = 0
    top_scorer = []
    self.stat_lines.each do |stats|
      if stats.points > top_points
        top_points = stats.points
        top_scorer = [stats]
      elsif stats.points == top_points
        top_scorer << stats
      end
    end
    display_top_scorer(top_scorer)
  end

  def display_top_scorer(top_scorer_array)
    top_scorer = {}
    top_scorer[:stat_value] = top_scorer_array.first.points
    if top_scorer_array.length == 1
      top_scorer[:name] = top_scorer_array.first.player.name
      top_scorer[:team] = top_scorer_array.first.team.name
      top_scorer[:points] = top_scorer_array.first.points
    else
      top_scorer[:name] = "#{top_scorer_array.length} Players"
      top_scorer[:team] = false
      top_scorer[:points] = top_scorer_array.first.points
    end 
    top_scorer
  end

  def second_top_performer
    second_stats = 0
    ties = []
    self.stat_lines.each do |stats|
      max_weighted_stat = stats.weighted_stats.max_by{|k, v| v}
      if max_weighted_stat[1] >= second_stats
        second_stats = max_weighted_stat[1]
        stp = {}
        stp[:player] = stats.player.name
        stp[:stat_name] = max_weighted_stat[0]
        stp[:team] = stats.team.name
        get_unweighted_stat_value(stp, stats)
        ties << stp
      end
    end
    # binding.pry
    if ties.length > 1
      decide_ties(ties)
    else
      second
    end
  end

#rebounds
#assists
#steals
#blocks

  def decide_ties(ties_array)
    second_top_performer = {}
    ties_array.map do |stat|
      determine_stat_priority(stat)
    end
    ties_array = ties_array.sort_by { |stat| stat[:priority_num] }
    # binding.pry
    count = Hash.new(0)
    ties_array.each do |stat|
      count[stat[:stat_name]] += 1
    end
    # binding.pry
    if count[ties_array.first[:stat_name]] == 1
      second_top_performer[:name] = ties_array.first[:player]
      second_top_performer[:stat_name] = ties_array.first[:stat_name]
      second_top_performer[:team] = ties_array.first[:team]
      second_top_performer[:stat_value] = ties_array.first[:stat_value]
    else
      second_top_performer[:name] = "#{count[ties_array.first[:stat_name]]} Players"
      second_top_performer[:team] = false
      second_top_performer[:stat_value] = ties_array.first[:stat_value]
      second_top_performer[:stat_name] = ties_array.first[:stat_name]
    end
    second_top_performer
  end

  def determine_stat_priority(stat)
    case stat[:stat_name]
    when :Rebounds
      stat[:priority_num] = 1
    when :Assists
      stat[:priority_num] = 2
    when :Steals
      stat[:priority_num] = 3
    when :Blocks 
      stat[:priority_num] = 4
    end
  end


  def third_top_performer
    third_stats = 0
    ties = []
    self.stat_lines.each do |stats|
      max_weighted_stat = stats.weighted_stats.max_by{|k, v| v}
      # can't be from same category as second_top_performer
      if max_weighted_stat[0] != self.second_top_performer[:stat_name] && max_weighted_stat[1] > third_stats
        third_stats = max_weighted_stat[1]
        third = {}
        third[:player] = stats.player.name
        third[:stat_name] = max_weighted_stat[0]
        third[:team] = stats.team.name
        get_unweighted_stat_value(third, stats)
        ties << third
      end
    end
    if ties.length > 1
      decide_ties(ties)
    else
      ties.first
    end
  end 

  def get_unweighted_stat_value(second, stats)
    case second[:stat_name]
    when :Rebounds
      second[:stat_value] = stats.trb
    when :Assists
      second[:stat_value] = stats.ast
    when :Steals
      second[:stat_value] = stats.stl
    when :Blocks
      second[:stat_value] = stats.blk
    end
  end

  def player_of_the_game
    player_of_game = {}
    top_wpa = 0
    player_stats = ''
    self.stat_lines.each do |stats|
      if stats.team_id == self.winner
        weighted_stats = stats.weighted_stats
        weighted_stats[:Points] = (stats.points * 0.1)
        wpa = weighted_stats.values.inject{|sum, x| sum + x}
        if wpa > top_wpa
          top_wpa = wpa
          player_stats = stats
        end
      end
    end
    player_of_game[:wpa] = top_wpa
    player_of_game[:name] = player_stats.player.name
    player_of_game[:team] = Team.find_by_id(self.winner).name
    player_of_game[:Rebounds] = player_stats.trb
    player_of_game[:Assists] = player_stats.ast
    player_of_game[:Steals] = player_stats.stl
    player_of_game[:Blocks] = player_stats.blk
    player_of_game[:Points] = player_stats.points
    player_of_game
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