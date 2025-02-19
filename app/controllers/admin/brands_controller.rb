class Admin::BrandsController < ApplicationController
    include AdminAuthentication
    before_action :set_brand, only: %i[ show edit update destroy ]
    def index
      @brands = Brand.all
    end
  
    def show
      @products = @brand.products
    end
  
    def new
      @brand = Brand.new
    end
  
    def create
      @brand = Brand.new(brand_params)
      if @brand.save
        flash[:notice]= "ブランド情報を登録しました！"
        redirect_to admin_brand_path(@brand)
      else
        render :new, status: :unprocessable_entity
      end
    end
  
    def edit
    end
  
    def update
      if @brand.update(brand_params)
        flash[:notice]= "ブランド情報を更新しました！"
        redirect_to admin_brand_path(@brand)
      else
        render :edit, status: :unprocessable_entity
      end
    end
  
    def destroy
      @brand.destroy
      flash[:notice]= "ブランド情報を削除しました！"
      redirect_to admin_brands_path
    end
  
    private
    def set_brand
      @brand = Brand.find(params[:id])
    end
    
    def brand_params
      params.require(:brand).permit(:name)
    end
  end