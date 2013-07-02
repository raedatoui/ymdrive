class AddPathToGFile < ActiveRecord::Migration
  def change
    add_column :g_files, :path, :string
  end
end
