class CreateYarns < ActiveRecord::Migration[5.1]
  def change
    create_table :yarns do |t|
      t.string :name
      t.string :size
      t.timestamps
    end
  end
end
