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
          flash[:notice]= "商品情報を登録しました！"
          redirect_to product_path(@product)
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
    end
  
    def update
      if @product.update(product_params)
        flash[:notice]= "商品情報を更新しました！"
        redirect_to product_path(@product)
      else
        render :edit, status: :unprocessable_entity
      end
    end
    
    def destroy
        @product.destroy
        flash[:notice]= "商品情報を削除しました！"
        redirect_to products_path
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
