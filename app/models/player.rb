class Player < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :key, :height, :weight, :age, :profile_pic, :team_id, :number
  validates :first_name, :last_name, :key, presence: true
  validates :key, uniqueness: { case_sensitive: false }

  has_attached_file :profile_pic, styles: { medium: "300x300>", profile: "200X200>", thumb: "100x100>" }

  belongs_to :team
  has_many :stat_lines, dependent: :destroy

  before_validation do
    self.key = key.strip
  end

  def name
    "#{first_name} #{last_name}"
  end
end