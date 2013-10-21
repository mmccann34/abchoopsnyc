class AddTypeToCareerHigh < ActiveRecord::Migration
  def change
    add_column :career_highs, :stat_type, :string
  end
end
