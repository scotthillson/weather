class CreateTemperatures < ActiveRecord::Migration
  def change
    create_table :temperatures do |t|
      t.integer :temperature
      t.string :latitude
      t.string :longitude
      t.string :location
      t.string :name
      t.integer :elevation
      t.decimal :precipitation
      t.decimal :altimiter

      t.timestamps
    end
  end
end
