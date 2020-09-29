class CreateDrafts < ActiveRecord::Migration[5.1]
  def change
    create_table :drafts do |t|
      t.belongs_to :user
      t.belongs_to :yarn
      t.string :name
      t.string :slug
      t.json :draft
      t.boolean :public
      t.timestamps
    end
  end
end
