class CreateDateRanges < ActiveRecord::Migration
  def change
    create_table :date_ranges do |t|
      t.date :start_date
      t.date :end_date
      t.string :name
      t.boolean :playoffs

      t.timestamps
    end
  end
end
