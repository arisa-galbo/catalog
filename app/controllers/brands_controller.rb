class BrandsController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]
  before_action :set_brand, only: %i[ show edit update destroy ]
  def index
    @brands = Brand.all
  end

  def show
  end

  def new
    @brand = Brand.new
  end

  def create
    @brand = Brand.new(brand_params)
    if @brand.save
      redirect_to @brand
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @brand.update(brand_params)
      redirect_to @brand
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @brand.destroy
    redirect_to brands_path
  end

  private
  def set_brand
    @brand = Brand.find(params[:id])
  end
  
  def brand_params
    params.expect(brand: [ :name ])
  end
end
