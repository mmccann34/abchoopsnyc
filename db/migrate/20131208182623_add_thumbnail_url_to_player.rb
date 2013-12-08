class AddThumbnailUrlToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :profile_pic_thumb_url, :string
  end
end
