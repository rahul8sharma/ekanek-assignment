class AddTockenColumnToDocumentTable < ActiveRecord::Migration[5.0]
  def change
    add_column :documents, :token, :string
  end
end
