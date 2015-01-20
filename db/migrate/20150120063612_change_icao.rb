class ChangeIcao < ActiveRecord::Migration
  def change
    rename_column :locations, :icao, :code
  end
end
