class AddTeamPhotoUrlToTeamSpot < ActiveRecord::Migration
  def change
    add_column :team_spots, :team_photo_url, :string
  end
end
