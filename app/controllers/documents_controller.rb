class DocumentsController < ApplicationController
  before_action :set_document, only: %i[ show edit update destroy compress download ]

  # GET /documents or /documents.json
  def index
    @documents = current_user.documents
  end

  # GET /documents/1 or /documents/1.json
  def show
    flash.now[:notice] = params[:flash_msg] if params[:flash_msg].present?
  end

  # GET /documents/new
  def new
    @document = Document.new
  end

  # GET /documents/1/edit
  # def edit
  # end

  # POST /documents or /documents.json
  def create
    original_filename = params[:original_filename]
    dir  = Rails.root.join('tmp', 'document').to_s
    filename = "#{SecureRandom.uuid}#{File.extname(original_filename)}"
    FileUtils.mkdir_p(dir) unless File.exist?(dir)

    @document = current_user.documents.new(
      original_filename: original_filename,
      path: File.join(dir, filename),
      filename: filename
    )

    if @document.save
      render json: { id: @document.id, uploaded_size: @document.uploaded_size }
    else
      render json: { error: @document.errors }
    end
  end

  def chunk_create
    file    = params[:document]
    @document = Document.find_by(id: params[:id])
    @document.uploaded_size += file.size

    if @document.save
      File.open(@document.path, 'ab') { |f| f.write(file.read) }
      render json: { id: @document.id, uploaded_size: @document.uploaded_size }
    else
      render json: { error: @document.errors }, status: 422
    end
  end

  def compress
    require 'zip'

    folder =  Rails.root.join('tmp', 'document').to_s
    zipfile_name = "#{folder}/#{@document.filename.split('.').first}.zip"
    file_name = @document.path.split('/').last

    @document.update_attributes(title:params[:title], description: params[:description])

    Zip::File.open(zipfile_name, create: true, compression_level: 9) do |zipfile|
      zipfile.add(file_name, File.join(folder, file_name))
      zipfile.get_output_stream("myFile") { |f| f.write "myFile contains just this" }
    end
  end

  def download
    send_data File.read(@document.path), filename: @document.original_filename
  end

  # PATCH/PUT /documents/1 or /documents/1.json
  # def update
  #   respond_to do |format|
  #     if @document.update(document_params)
  #       format.html { redirect_to document_url(@document), notice: "Document was successfully updated." }
  #       format.json { render :show, status: :ok, location: @document }
  #     else
  #       format.html { render :edit, status: :unprocessable_entity }
  #       format.json { render json: @document.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /documents/1 or /documents/1.json
  # def destroy
  #   @document.destroy

  #   respond_to do |format|
  #     format.html { redirect_to documents_url, notice: "Document was successfully destroyed." }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def document_params
      params.require(:document).permit(:title, :description, :original_filename)
    end
end
