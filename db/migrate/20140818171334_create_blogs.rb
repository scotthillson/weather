class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.string :author
      t.string :body
      t.string :title

      t.timestamps
    end
  end
end
