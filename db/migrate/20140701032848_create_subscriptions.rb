class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :email
      t.string :frequency
      t.boolean :rain
      t.boolean :high
      t.boolean :low
      t.integer :location_id

      t.timestamps
    end
  end
end
