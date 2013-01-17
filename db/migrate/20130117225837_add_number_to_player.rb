class AddNumberToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :number, :integer
  end
end
