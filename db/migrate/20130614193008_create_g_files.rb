class CreateGFiles < ActiveRecord::Migration
  def change
    create_table :g_files do |t|
      t.string :file_id

      t.timestamps
    end
  end
end
