class AddAboutFieldsToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :league_love, :string
    add_column :players, :little_known_fact, :string
    add_column :players, :did_you_know, :string
    add_column :players, :one_last_thing, :string
  end
end
