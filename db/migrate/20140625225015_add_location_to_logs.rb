class AddLocationToLogs < ActiveRecord::Migration
  def change
    add_column :logs, :location, :string
  end
end
