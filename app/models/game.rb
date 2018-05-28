class Game < ActiveRecord::Base
  attr_accessible :away_team_id, :home_team_id, :season_id, :home_score_first, :home_score_second, :home_score_ot_one, :home_score_ot_two, :home_score_ot_three, 
  :away_score_first, :away_score_second, :away_score_ot_one, :away_score_ot_two, :away_score_ot_three, :date, :time, :location_id, :forfeit, :winner, :league_id,
  :playoff_round, :no_of_urls, :url_template, :photo_urls
  serialize :photo_urls
  
  attr_writer :url_template, :url_number, :no_of_urls

  validates :away_team_id, :home_team_id, :location_id, :league_id, :season_id, presence: true

  belongs_to :home_team, class_name: 'Team', foreign_key: 'home_team_id'
  belongs_to :away_team, class_name: 'Team', foreign_key: 'away_team_id'
  belongs_to :winning_team, class_name: 'Team', foreign_key: 'winner'
  belongs_to :season
  belongs_to :location
  belongs_to :league

  has_many :stat_lines, dependent: :destroy
  has_many :top_performers, dependent: :destroy

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

  def save_top_performers
    top_performers = self.top_performers.order(:performer_type)

    #Could probably combine these more
    #Top Scorer
    top_scorer = top_performers[0] || self.top_performers.new(performer_type: 1)
    ts = self.top_scorer
    top_scorer.attributes = {player_id: ts[:player].try(:id), name: ts[:name], team_id: ts[:team].try(:id), stat: "#{ts[:points]} Points"}
    top_scorer.save

    # Second Top Perfomer
    top_perfs = self.new_top_performers
    stp = top_perfs[0][0]
    if stp
      second_peformer = top_performers[1] || self.top_performers.new(performer_type: 2)
      second_peformer.attributes = {player_id: stp[:player].try(:id), name: stp[:name], team_id: stp[:team].try(:ids), stat: stp[:stat]}
      # TEAM ID NOT BEING PASSED
      second_peformer.save
    end

    # Third Top Perfomer
    top_perfs = self.new_top_performers
    ttp = top_perfs[1][0]
    if ttp
      third_peformer = top_performers[2] || self.top_performers.new(performer_type: 3)
      third_peformer.attributes = {player_id: ttp[:player].try(:id), name: ttp[:name], team_id: ttp[:team].try(:ids), stat: ttp[:stat]}
      third_peformer.save
    end
  end

  def top_scorer
    top_points = 0
    top_scorer = []
    self.stat_lines.includes(:player).each do |stats|
      next if stats.player.nil?
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
      top_scorer[:player] = top_scorer_array.first.player
      if !top_scorer[:player]
      end
      top_scorer[:name] = top_scorer_array.first.player.first_name_last_int
      top_scorer[:team] = top_scorer_array.first.team
      top_scorer[:points] = top_scorer_array.first.points.round
    else
      top_scorer[:name] = "#{top_scorer_array.length} Players"
      top_scorer[:team] = nil
      top_scorer[:points] = "#{top_scorer_array.first.points.round}"
    end 
    top_scorer
  end


  def new_top_performers
    #SET TO ZERO TO COMPARE TO STAT
    second_ties = []
    third_ties = []

    new_ties = [[],[]]

    stp = {:stat_name => ""}

    @all_stats ||= {}
    @all_stats[:Rebounds] = [0]
    @all_stats[:Assists] = [0]
    @all_stats[:Steals] = [0]
    @all_stats[:Blocks] = [0]

    #GO THROUGH EACH PLAYER'S STATS
    self.stat_lines.includes(:player).each do |stats|

      #if didnt play dont go through
      next if stats.dnp == true

      if stats.trb >= @all_stats[:Rebounds][0]
        if stats.trb >= @all_stats[:Rebounds][0]
          #CLEAR TIES
        end
        @all_stats[:Rebounds][0] = stats.trb
        @all_stats[:Rebounds][1] = (stats.trb * 0.12)
        @all_stats[:Rebounds][2] = stats.player
      end
      if stats.ast >= @all_stats[:Assists][0]
        if stats.ast >= @all_stats[:Assists][0]
          #CLEAR TIES
        end
        @all_stats[:Assists][0] = stats.ast
        @all_stats[:Assists][1] = (stats.ast * 0.22)
        @all_stats[:Assists][2] = stats.player
      end
      if stats.stl >= @all_stats[:Steals][0]
        if stats.stl >= @all_stats[:Steals][0]
          #CLEAR TIES
        end
        @all_stats[:Steals][0] = stats.stl
        @all_stats[:Steals][1] = (stats.stl * 0.17)
        @all_stats[:Steals][2] = stats.player
      end
      if stats.blk >= @all_stats[:Blocks][0]
        if stats.blk >= @all_stats[:Blocks][0]
          #CLEAR TIES
        end
        @all_stats[:Blocks][0] = stats.blk
        @all_stats[:Blocks][1] = (stats.blk * 0.34)
        @all_stats[:Blocks][2] = stats.player
      end
    end

    top_two = @all_stats.max_by(2){|id, (v,w,p)| w}.flatten

    stp = {}
    stp[:name] = top_two[3].first_name_last_int
    stp[:stat_name] = top_two[0].to_s
    stp[:team] = top_two[3].teams
    stp[:player] = top_two[3]
    get_unweighted_stat_value(stp, top_two[1])

    ttp = {}
    ttp[:name] = top_two[7].first_name_last_int
    ttp[:stat_name] = top_two[4].to_s
    ttp[:team] = top_two[7].teams
    ttp[:player] = top_two[7]
    get_unweighted_stat_value(ttp, top_two[5])

    top_perfs = [[],[]]
    top_perfs[0] << stp
    top_perfs[1] << ttp

    return top_perfs
    # return stp

    # end
  end

  def second_top_performer
    second_stats = 0
    ties = []
    self.stat_lines.includes(:player).each do |stats|
      next if stats.player.nil?
      max_weighted_stat = stats.weighted_stats.max_by{|k, v| v}
      if max_weighted_stat[1] >= second_stats
        if max_weighted_stat[1] > second_stats
          ties.clear
        end
        second_stats = max_weighted_stat[1]
        stp = {}
        stp[:name] = stats.player.first_name_last_int
        stp[:stat_name] = max_weighted_stat[0]
        stp[:team] = stats.team
        stp[:player] = stats.player
        get_unweighted_stat_value(stp, stats)
        ties << stp
      end
    end
    if ties.length > 1
      decide_ties(ties)
    else
      # ties.first[:ties] = false
      return ties.first
    end
  end

  def decide_ties(ties_array)
    top_performer = {}
    ties_array.map do |stat|
      determine_stat_priority(stat)
    end
    ties_array = ties_array.sort_by { |stat| stat[:priority_num] }
    count = Hash.new(0)
    ties_array.each do |stat|
      count[stat[:stat_name]] += 1
    end
    if count[ties_array.first[:stat_name]] == 1
      # top_performer[:ties] = true
      top_performer[:name] = ties_array.first[:name]
      top_performer[:team] = ties_array.first[:team]
      top_performer[:stat] = ties_array.first[:stat]
      top_performer[:stat_name] = ties_array.first[:stat_name]
    else
      # top_performer[:ties] = true
      top_performer[:name] = "#{count[ties_array.first[:stat_name]]} Players"
      top_performer[:team] = nil
      top_performer[:stat] = ties_array.first[:stat]
      top_performer[:stat_name] = ties_array.first[:stat_name]
    end
    top_performer
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


  def third_top_performer(second_top_perfomer_stat_name = self.second_top_performer[:stat_name])
    third_stats = 0
    ties = []
    self.stat_lines.includes(:player).each do |stats|
      next if stats.player.nil?
      max_weighted_stat = stats.weighted_stats.max_by{|k, v| v}
      # can't be from same category as second_top_performer
      if max_weighted_stat[0] != second_top_perfomer_stat_name && max_weighted_stat[1] >= third_stats
        if max_weighted_stat[1] > third_stats
          ties.clear
        end
        third_stats = max_weighted_stat[1]
        third = {}
        third[:name] = stats.player.first_name_last_int
        third[:stat_name] = max_weighted_stat[0]
        third[:team] = stats.team
        third[:player] = stats.player
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

  def get_unweighted_stat_value(second, number)
    case second[:stat_name]
    when "Rebounds"
      second[:stat] = "#{number.to_i} #{second[:stat_name]}"
    when "Assists"
      second[:stat] = "#{number.to_i} #{second[:stat_name]}"
    when "Steals"
      second[:stat] = "#{number.to_i} #{second[:stat_name]}"
    when "Blocks"
      second[:stat] = "#{number.to_i} #{second[:stat_name]}"
    end
  end

  def player_of_the_game
    player_of_game = {}
    top_wpa = 0
    player_stats = ''
    self.stat_lines.each do |stats|
      next if stats.player.nil?
      if stats.team_id == self.winner
        weighted_stats = stats.weighted_stats
        weighted_stats[:Points] = (stats.points * 0.15)
        wpa = weighted_stats.values.inject{|sum, x| sum + x}
        if wpa > top_wpa
          top_wpa = wpa
          player_stats = stats
        end
      end
    end
    if player_stats != ''
      player_of_game[:wpa] = ((top_wpa/self.team_wpa)*100).round(1)
      player_of_game[:name] = player_stats.player.first_name_last_int
      player_of_game[:player] = player_stats.player
      player_of_game[:team] = Team.find_by_id(self.winner)
      player_of_game[:Rebounds] = player_stats.trb > 0 ? "#{player_stats.trb.round} Rbs" : nil
      player_of_game[:Assists] = player_stats.ast > 0 ? "#{player_stats.ast.round} Ast" : nil
      player_of_game[:Steals] = player_stats.stl > 0 ? "#{player_stats.stl.round} Stl" : nil
      player_of_game[:Blocks] = player_stats.blk > 0 ? "#{player_stats.blk.round} Blk" : nil
      player_of_game[:Points] = player_stats.points > 0 ? "#{player_stats.points.round} Pts" : nil
      player_of_game[:stats_1] = player_of_the_game_stats([player_of_game[:Points], player_of_game[:Rebounds]])
      player_of_game[:stats_2] = player_of_the_game_stats([player_of_game[:Assists], player_of_game[:Blocks], player_of_game[:Steals]])
    else
      player_of_game = false
    end
    player_of_game
  end

  def team_wpa
    team_wpa = 0
    self.stat_lines.each do |stats|
      next if stats.player.nil?
      if stats.team_id == self.winner
        weighted_stats = stats.weighted_stats
        weighted_stats[:Points] = (stats.points * 0.15)
        team_wpa += weighted_stats.values.inject{|sum, x| sum + x}
      end
    end
    team_wpa
  end

  def player_of_the_game_stats(stats)
    stats_string = ''
    stats = stats.compact
    stats.each_with_index do |stat, i|
      if i == stats.length - 1
        stats_string += stat
      else
        stats_string += "#{stat}, "
      end
    end
    stats_string
  end

  def url_template
    unless self.photo_urls.blank?
      self.photo_urls.first.to_s.split(/\d*.jpg/).first
    end
  end

  def url_number
    @url_number.nil? ? photo_urls.to_s.split(/(?!\d*.jpg)./).last.to_i : @url_number
  end

  def no_of_urls

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
        # roster_spot.update_attribute(:jersey_number, stat_line.jersey_number)
      else
        if !roster_spot.jersey_number
          roster_spot.update_attribute(:jersey_number, stat_line.jersey_number)
        end
      end
    end
  end
end