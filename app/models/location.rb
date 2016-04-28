class Location < ActiveRecord::Base
  attr_accessible :map_url, :address, :name
  has_many :games
end
