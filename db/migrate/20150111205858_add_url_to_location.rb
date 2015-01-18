class AddUrlToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :url, :string
  end
end
