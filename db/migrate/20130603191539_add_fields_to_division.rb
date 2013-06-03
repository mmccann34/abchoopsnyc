class AddFieldsToDivision < ActiveRecord::Migration
  def change
    add_column :divisions, :name, :string
    add_column :divisions, :season_id, :integer
  end
end
