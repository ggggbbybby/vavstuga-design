class CreateYarns < ActiveRecord::Migration[5.1]
  def change
    create_table :yarns do |t|
      t.string :name
      t.string :size
      t.string :slug
      t.json :colors
      t.timestamps
    end
  end
end
