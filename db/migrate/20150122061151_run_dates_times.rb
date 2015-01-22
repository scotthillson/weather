class RunDatesTimes < ActiveRecord::Migration
  def change
    add_column :runs, :run_time, :datetime
  end
end
