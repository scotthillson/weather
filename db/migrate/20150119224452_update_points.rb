class UpdatePoints < ActiveRecord::Migration
  def change
    rename_column :points, :cloud, :cloud_cover
    rename_column :points, :rain, :rain_inches_predicted
    add_column :points, :precipitation_potential, :integer
    rename_column :points, :high, :high_temperature_predicted
    rename_column :points, :low, :low_temperature_predicted
    add_column :points, :mean_temperature_predicted, :integer
    add_column :points, :rain_description, :string
    add_column :points, :thunder_description, :string
    add_column :points, :snow_description, :string
    add_column :points, :freezing_rain_description, :string
    add_column :points, :sleet_description, :string
    add_column :points, :surface_wind_predicted, :integer
    add_column :points, :wind_chill_predicted, :integer
    add_column :points, :dewpoint_predicted, :integer
  end
end
