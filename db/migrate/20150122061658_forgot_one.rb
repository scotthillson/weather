class ForgotOne < ActiveRecord::Migration
  def change
    add_column :runs, :location_id, :integer
  end
end
