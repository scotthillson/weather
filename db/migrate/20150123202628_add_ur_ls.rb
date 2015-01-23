class AddUrLs < ActiveRecord::Migration
  def change
    add_column :locations, :url_two, :text
    add_column :locations, :url_three, :text
    change_column :locations, :url, :text
  end
end
