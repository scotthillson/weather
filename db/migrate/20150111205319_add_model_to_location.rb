class AddModelToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :model, :string
  end
end
