class Document < ApplicationRecord
  belongs_to :user

  attr_accessor :file

  before_create :create_filename
  before_create :modify_columns

  def uploaded_size_in_megabytes
    "#{(self.uploaded_size.to_f / 1000000).round(2)} MB"
  end

  private

  def modify_columns
    dir  = Rails.root.join('tmp', 'document').to_s
    FileUtils.mkdir_p(dir) unless File.exist?(dir)

    self.path = File.join(dir, self.filename)
  end

  def create_filename
    self.filename = loop do
      new_filename = "#{SecureRandom.uuid}#{File.extname(self.original_filename)}"
      break new_filename unless Document.exists?(filename: new_filename)
    end
  end
end
