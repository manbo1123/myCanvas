class AddNoteToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :note, :text
    add_column :posts, :purpose, :text
    add_column :posts, :vision, :text
  end
end
