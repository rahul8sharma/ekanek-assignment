class CreateDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :documents do |t|
      t.string :title
      t.text :description
      t.string :original_filename
      t.string :filename
      t.string :path
      t.integer :uploaded_size, default: 0
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
