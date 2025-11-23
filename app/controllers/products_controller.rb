class ProductsController < ApplicationController
  def index
    @products = Product.includes(images_attachments: :blob).order(created_at: :desc)
    @product = Product.new
  end

  def create
    product_id = params[:product_id]
    @products = Product.includes(images_attachments: :blob).order(created_at: :desc)
    @was_new_product = false

    if product_id.present? && product_id != "" && product_id != "new"
      # Attach to existing product
      @product = Product.find(product_id)
      if product_params[:images].present?
        @new_attachments = @product.images.attach(product_params[:images])
        if @new_attachments.present?
          @product.reload
          respond_to do |format|
            format.turbo_stream
            format.html { redirect_to products_path, notice: "Images added to product successfully." }
          end
        else
          respond_to do |format|
            format.turbo_stream do
              render turbo_stream: turbo_stream.replace("product_form", partial: "form", locals: { product: Product.new, products: @products })
            end
            format.html { render :index, status: :unprocessable_entity }
          end
        end
      else
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("product_form", partial: "form", locals: { product: Product.new, products: @products })
          end
          format.html { redirect_to products_path, alert: "Please select at least one image." }
        end
      end
    else
      # Create new product
      @product = Product.new(product_params.except(:images))
      @was_new_product = true

      if @product.save
        if product_params[:images].present?
          @product.images.attach(product_params[:images])
        end
        @product.reload
        @products = Product.includes(images_attachments: :blob).order(created_at: :desc)
        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to products_path, notice: "Product created successfully." }
        end
      else
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("product_form", partial: "form", locals: { product: @product, products: @products })
          end
          format.html { render :index, status: :unprocessable_entity }
        end
      end
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, images: [])
  end
end
