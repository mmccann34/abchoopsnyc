class AddShorNameToLeague < ActiveRecord::Migration
  def change
    add_column :leagues, :short_name, :string
  end
end
