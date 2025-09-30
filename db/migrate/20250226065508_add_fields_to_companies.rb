class AddFieldsToCompanies < ActiveRecord::Migration[7.1]
  def change
    add_column :companies, :phone, :string
    add_column :companies, :email, :string
    add_column :companies, :description, :text
  end
end
