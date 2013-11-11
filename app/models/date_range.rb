class DateRange < ActiveRecord::Base
  attr_accessible :end_date, :name, :playoffs, :start_date, :short_name, :league_id
  
  belongs_to :season
  belongs_to :league
end
