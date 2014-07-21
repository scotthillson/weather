class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :action
      t.string :note
      t.string :run

      t.timestamps
    end
  end
end
