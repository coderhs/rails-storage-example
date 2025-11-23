class UploadsController < ApplicationController
  def index
    @uploads = Upload.includes(file_attachment: :blob).order(created_at: :desc)
  end

  def create
    @upload = Upload.new(upload_params)

    if @upload.save
      @attachment = @upload.file.attachment
      @blob = @upload.file.blob
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to uploads_path, notice: "File uploaded successfully." }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("upload_form", partial: "form", locals: { upload: @upload })
        end
        format.html do
          @uploads = Upload.includes(file_attachment: :blob).order(created_at: :desc)
          render :index, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    @upload = Upload.find(params[:id])
    @attachment = @upload.file.attachment
    @blob = @upload.file.blob
    @upload.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to uploads_path, notice: "File deleted successfully." }
    end
  end

  def direct_upload
    @uploads = Upload.includes(file_attachment: :blob).order(created_at: :desc)
  end

  def create_direct_upload
    @upload = Upload.new(upload_params)

    if @upload.save
      respond_to do |format|
        format.json { render json: { success: true, upload: { id: @upload.id, name: @upload.name } }, status: :created }
        format.html { redirect_to direct_upload_path, notice: "File uploaded successfully." }
      end
    else
      respond_to do |format|
        format.json { render json: { success: false, errors: @upload.errors.full_messages }, status: :unprocessable_entity }
        format.html do
          @uploads = Upload.includes(file_attachment: :blob).order(created_at: :desc)
          render :direct_upload, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def upload_params
    params.require(:upload).permit(:name, :file)
  end

end
