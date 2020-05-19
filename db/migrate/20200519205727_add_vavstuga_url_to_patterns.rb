class AddVavstugaUrlToPatterns < ActiveRecord::Migration[5.1]
  def change
    add_column :patterns, :vavstuga_product_url, :string
    add_column :patterns, :vavstuga_category_url, :string
  end
end
