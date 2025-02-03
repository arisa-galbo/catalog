class ProductsController < ApplicationController
    allow_unauthenticated_access only: %i[ show ]
    before_action :set_brand
    before_action :set_product, only: [:show, :edit, :update, :destroy]

    def show
    end

    def new
        @product = @brand.products.new
      end

    def create
        @product = @brand.products.new(product_params)
        if @product.save
            redirect_to brand_product_path(@brand, @product), notice: "商品が登録されました！"
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
    end
  
    def update
      if @product.update(product_params)
        redirect_to brand_product_path(@brand, @product), notice: "商品が更新されました！"
      else
        render :edit, status: :unprocessable_entity
      end
    end
    
    def destroy
        @product.destroy
    redirect_to brand_products_path(@brand), notice: "商品が削除されました！"
      end

    private
  
    def set_brand
      @brand = Brand.find(params[:brand_id])
    end
  
    def set_product
      @product = @brand.products.find(params[:id])
    end

    def product_params
        params.require(:product).permit(:name, :price, :body, :production_started_on)
      end
end
