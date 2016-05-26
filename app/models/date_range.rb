class DateRange < ActiveRecord::Base
  attr_accessible :end_date, :name, :playoffs, :start_date, :short_name, :league_id
  
  belongs_to :season
  belongs_to :league

  validate :prevent_old_dates

  private

  def prevent_old_dates
    if ( start_date || end_date ) < Date.parse("2010-12-31")
      errors[:base] << "Date must be after 2010."
    end
  end
end