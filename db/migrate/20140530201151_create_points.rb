class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.text :time
      t.integer :high
      t.integer :low
      t.decimal :rain
      t.integer :cloud
      t.integer :run_id

      t.timestamps
    end
  end
end
