class SeparateGoogleCalendarIds < ActiveRecord::Migration
  def change
    remove_column :games, :google_calendar_id, 
    add_column :games, :home_team_google_calendar_id, :string
    add_column :games, :away_team_google_calendar_id, :string
  end
end