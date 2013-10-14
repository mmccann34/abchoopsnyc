class AddProfilePicUrlToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :profile_pic_url, :string
  end
end
