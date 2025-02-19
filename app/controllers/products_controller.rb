class ProductsController < ApplicationController
    before_action :set_product, only: :show

    def index
      @products = Product.includes(:brand).all
    end

    def show
      @brand = @product.brand
    end

    private
    def set_product
      @product = Product.find(params[:id])
    end
  
    def set_brand
      @brand = Brand.find(params[:brand_id])
    end

    def product_params
        params.require(:product).permit(:name, :price, :body, :production_started_on, :image_url)
    end
end
