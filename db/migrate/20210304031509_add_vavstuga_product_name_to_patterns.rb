class AddVavstugaProductNameToPatterns < ActiveRecord::Migration[5.1]
  def change
    add_column :patterns, :vavstuga_product_name, :string
  end
end
