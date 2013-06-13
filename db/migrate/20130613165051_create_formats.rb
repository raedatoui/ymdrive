class CreateFormats < ActiveRecord::Migration
  def change
    create_table :formats do |t|
      t.string :label
      t.string :format
      t.string :mimetype
      t.string :icon

      t.timestamps
    end
  end
end
