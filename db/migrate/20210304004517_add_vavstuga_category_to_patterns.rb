class AddVavstugaCategoryToPatterns < ActiveRecord::Migration[5.1]
  def change
    add_column :patterns, :vavstuga_category_name, :string
  end
end
