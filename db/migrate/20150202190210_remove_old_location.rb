class RemoveOldLocation < ActiveRecord::Migration
  def change
    remove_column :runs, :location
  end
end
