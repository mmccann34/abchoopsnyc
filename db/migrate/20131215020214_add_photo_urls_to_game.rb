class AddPhotoUrlsToGame < ActiveRecord::Migration
  def change
    add_column :games, :photo_urls, :text
  end
end
