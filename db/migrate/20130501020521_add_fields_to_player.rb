class AddFieldsToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :height_feet, :integer
    add_column :players, :height_inches, :integer
    add_column :players, :school, :string
    add_column :players, :position, :string
  end
end
