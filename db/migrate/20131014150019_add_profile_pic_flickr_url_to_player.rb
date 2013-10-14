class AddProfilePicFlickrUrlToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :profile_pic_flickr_url, :string
  end
end
