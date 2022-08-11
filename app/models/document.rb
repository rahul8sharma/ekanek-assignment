class Document < ApplicationRecord
  belongs_to :user

  attr_accessor :file

  before_create :set_token
  before_create :modify_columns

  def uploaded_size_in_megabytes
    "#{(self.uploaded_size.to_f / 1000000).round(2)} MB"
  end

  private

  def modify_columns
    dir  = Rails.root.join('tmp', 'document').to_s
    FileUtils.mkdir_p(dir) unless File.exist?(dir)

    self.filename = "#{self.token}#{File.extname(self.original_filename)}"
    self.path = File.join(dir, self.filename)
  end

  def set_token
		self.token = Document.generate_token
	end

  def self.generate_token
    loop do
      random_token = SecureRandom.hex(4)
      break random_token unless Document.exists?(token: random_token)
    end
  end
end
