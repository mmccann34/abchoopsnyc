class AddAttachmentProfilePicToPlayers < ActiveRecord::Migration
  def self.up
    change_table :players do |t|
      t.attachment :profile_pic
    end
  end

  def self.down
    drop_attached_file :players, :profile_pic
  end
end
