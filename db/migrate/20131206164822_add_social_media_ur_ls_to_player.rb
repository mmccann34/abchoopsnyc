class AddSocialMediaUrLsToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :social_media_urls, :text
  end
end
