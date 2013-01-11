class Player < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :key, :height, :weight, :age
  validates :first_name, :last_name, :key, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end
end