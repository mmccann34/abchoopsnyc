class AddGoogleCalendarIds < ActiveRecord::Migration
  def change
    add_column :teams, :google_calendar_id, :string
    add_column :games, :google_calendar_id, :string
  end
end
