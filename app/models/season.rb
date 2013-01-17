class Season < ActiveRecord::Base
  attr_accessible :key, :name
  validates :key, :name, presence: true

  has_many :games

  has_many :roster_entries, class_name: 'Roster', dependent: :destroy

  def self.current_season
    Season.find_by_current(true)
  end
end
