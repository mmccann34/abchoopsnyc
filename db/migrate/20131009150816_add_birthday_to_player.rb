class AddBirthdayToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :birthday, :date
  end
end
