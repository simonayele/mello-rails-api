class ProductsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def new
    @product = Product.new
  end

  def index
    @products = Product.all
  end

  def destroy
    @product = Product.find_by_id(params[:id])
    return render_not_found if @product.blank?
    return render_not_found(:forbidden) if @product.user != current_user
    @product.destroy
    redirect_to root_path
  end


  def update
    @product = Product.find_by_id(params[:id])
    return render_not_found if @product.blank?
    return render_not_found(:forbidden) if @product.user != current_user
    
    @product.update_attributes(product_params)
    
    if @product.valid?
      redirect_to root_path
    else
      return render :edit, status: :unprocessable_entity
    end
  end

  def edit
    @product = Product.find_by_id(params[:id])
    return render_not_found if @product.blank?
    return render_not_found(:forbidden) if @product.user != current_user
  end

  def show
    @product = Product.find_by_id(params[:id])
    return render_not_found if @product.blank?
    
  end

  def create
    @product = current_user.products.create(product_params)
    if @product.valid?
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end


private

  def product_params
    params.require(:product).permit(:name, :price, :description, :picture)
  end

    
end
