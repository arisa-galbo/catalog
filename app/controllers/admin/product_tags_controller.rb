class Admin::ProductTagsController < ApplicationController
    include AdminAuthentication
    before_action :set_product
    before_action :set_product_tag, only: [:edit, :update, :destroy]
    
    def new
        @product_tag = @product.product_tags.new
    end
    
    def create
        @product_tag = @product.product_tags.new(product_tag_params)
        if @product_tag.save
            flash[:notice] = "タグを追加しました！"
            redirect_to admin_product_path(@product)
        else
            render :new, status: :unprocessable_entity
        end
    end
    
    def edit
    end
    
    def update
        if @product_tag.update(product_tag_params)
            flash[:notice]= "タグを更新しました！"
            redirect_to admin_product_path(@product)
        else
            render :edit, status: :unprocessable_entity
        end
    end
    
    def destroy
        @product_tag.destroy
        flash[:notice]= "タグを削除しました！"
        redirect_to admin_product_path(@product)
    end
    
    private
    
    def set_product
        @product = Product.find(params[:product_id])
    end
    
    def set_product_tag
       @product_tag = ProductTag.find(params[:id]) 
    end
    
    def product_tag_params
        params.require(:product_tag).permit(:tag_id, :valid_from, :valid_to)
    end
end
