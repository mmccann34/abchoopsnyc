class AddInfoFieldsToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :height, :string
    add_column :players, :weight, :integer
    add_column :players, :age, :integer
  end
end
