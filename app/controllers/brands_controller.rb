class BrandsController < ApplicationController
  before_action :set_brand, only: :show
  def index
    @brands = Brand.all
  end

  def show
    @products = @brand.products
  end

  private
  def set_brand
    @brand = Brand.find(params[:id])
  end
  
  def brand_params
    params.require(:brand).permit(:name)
  end
end
