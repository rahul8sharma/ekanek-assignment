json.extract! document, :id, :title, :description, :filename, :original_filename, :path, :uploaded_size, :user_id, :created_at, :updated_at
json.url document_url(document, format: :json)
