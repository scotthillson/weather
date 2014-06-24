class CreateRuns < ActiveRecord::Migration
  def change
    create_table :runs do |t|
      t.string :run
      t.string :location
      t.string :model

      t.timestamps
    end
  end
end
