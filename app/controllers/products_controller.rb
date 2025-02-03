class ProductsController < ApplicationController
    allow_unauthenticated_access only: %i[ show ]
    before_action :set_brand
    before_action :set_product, only: [:show]
    def create
        @article = Article.find(params[:article_id])
        @comment = @article.comments.create(comment_params)
        redirect_to article_path(@article)
    end

    def show
    end

    private
  
    def set_brand
      @brand = Brand.find(params[:brand_id])
    end
  
    def set_product
      @product = @brand.products.find(params[:id])
    end
end
