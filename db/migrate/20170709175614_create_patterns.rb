class CreatePatterns < ActiveRecord::Migration[5.1]
  def change
    create_table :patterns do |t|
      t.belongs_to :user
      t.belongs_to :yarn
      t.string :name
      t.json :stripes
      t.json :default_colors
      t.boolean :public
      t.timestamps
    end
  end
end
