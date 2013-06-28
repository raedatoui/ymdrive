class AddExtensionToFormat < ActiveRecord::Migration
  def change
    add_column :formats, :extension, :string
  end
end
