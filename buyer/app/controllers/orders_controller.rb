class OrdersController < ApplicationController
   before_action :authenticate_user!
  
  def create
      @order = Order.new(order_params)
      @current_cart.order_items.each do |item|
      @order.order_items << item
      order.cart_id = nil
    end
      @order.save
      Cart.destroy(session[:cart_id])
      session[:cart_id] = nil
      redirect_to root_path
  end

  def index
    @orders = Order.all
  end

  def show
    @order = Order.find(params[:id])
  end

  def new
    @order = Order.new
  end


  private

    def order_params
      params.require(:order).permit(:total_price, :cart_id)
    end

end