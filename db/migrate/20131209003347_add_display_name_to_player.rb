class AddDisplayNameToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :display_name, :string
  end
end
