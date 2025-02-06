class ProductsController < ApplicationController
    allow_unauthenticated_access only: %i[ show index ]
    before_action :set_product, only: %i[ show edit update destroy ]
    before_action :set_brand, only: %i[ new create ]

    def index
      @products = Product.includes(:brand).all
    end

    def show
      @brand = @product.brand
    end

    def new
        @product = @brand.products.new
      end

    def create
        @product = @brand.products.new(product_params)
        if @product.save
            redirect_to product_path(@product), notice: "商品が登録されました！"
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
    end
  
    def update
      if @product.update(product_params)
        redirect_to product_path(@product), notice: "商品が更新されました！"
      else
        render :edit, status: :unprocessable_entity
      end
    end
    
    def destroy
        @product.destroy
        redirect_to products_path, notice: "商品が削除されました！"
      end

    private
  
    def set_product
      @product = Product.find(params[:id])
    end
  
    def set_brand
      @brand = Brand.find(params[:brand_id])
    end

    def product_params
        params.require(:product).permit(:name, :price, :body, :production_started_on)
      end
end
