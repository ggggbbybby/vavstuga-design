class AddBreadcrumbsToDrafts < ActiveRecord::Migration[5.1]
  def change
    add_column :drafts, :vavstuga_product_url, :string
    add_column :drafts, :vavstuga_category_url, :string
    add_column :drafts, :vavstuga_category_name, :string
    add_column :drafts, :vavstuga_product_name, :string
  end
end
