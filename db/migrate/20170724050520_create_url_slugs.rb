class CreateUrlSlugs < ActiveRecord::Migration[5.1]
  def change
    add_column :patterns, :slug, :string
  end
end
