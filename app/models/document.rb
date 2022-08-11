class Document < ApplicationRecord
  belongs_to :user

  attr_accessor :file

  def uploaded_size_in_megabytes
  "#{(uploaded_size.to_f / 1000000).round(2)} MB"
  end
end
