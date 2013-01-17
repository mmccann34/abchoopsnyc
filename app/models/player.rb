class Player < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :key, :height, :weight, :age, :profile_pic
  validates :first_name, :last_name, :key, presence: true
  validates :key, uniqueness: { case_sensitive: false }

  has_attached_file :profile_pic, styles: { medium: "300x300>", profile: "200X200>", thumb: "100x100>" }

  # Team associations
  has_many :roster_entries, class_name: 'Roster', dependent: :destroy
  has_one :current_roster_entry, class_name: 'Roster', conditions: { season_id: Season.current_season.try(:id) }, dependent: :destroy
  has_one :team, through: :current_roster_entry

  has_many :stat_lines, dependent: :destroy

  before_validation do
    self.key = key.strip
  end

  def name
    "#{first_name} #{last_name}"
  end
end