class Player < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :key, :height, :weight, :age, :profile_pic, :team_id, :number, :height_feet, :height_inches, :school, :position, :hometown
  validates :first_name, presence: true
  # validates :key, uniqueness: { case_sensitive: false }

  has_attached_file :profile_pic, styles: { medium: "300x300#", profile: "200X200#", thumb: "100x100#" }

  has_many :stat_lines, dependent: :destroy
  has_many :roster_spots, dependent: :destroy
  has_many :teams, through: :roster_spots

  before_validation do
    self.key = key.strip if key
  end

  def name
    "#{first_name} #{last_name}"
  end

  def height
    "#{height_feet}-#{height_inches}"
  end
end