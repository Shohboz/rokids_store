class OrdersController < ApplicationController
  skip_before_action :authorize, only: [:new, :create]
  include CurrentCart, CategoriesAvailable
  before_action :set_cart, :categories
  before_action :set_order, only: [:show, :edit, :update, :destroy, :shipped]
  before_action :set_cart, only: [:new, :create]

  # GET /orders
  def index
    @orders = Order.all
  end

  # GET /orders/1
  def show
  end

  # GET /orders/new
  def new
    if @cart.line_items.empty?
      redirect_to store_url, notice: "Ваша корзина пуста"
      return
    end
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  def create
    @order = Order.new(order_params)
    @order.add_line_items_from_cart(@cart)

    respond_to do |format|
      if @order.save
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        OrderNotifier.received(@order).deliver
        OrderNotifier.ordered(@order).deliver
        format.html { redirect_to store_url, notice: 'Спасибо, что сделали заказ в нашем магазине.' }
      else
        #@cart = current_cart
        #render :new
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /orders/1
  def update
    if @order.update(order_params)
      redirect_to @order, notice: 'Order was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /orders/1
  def destroy
    @order.destroy
    redirect_to orders_url, notice: 'Order was successfully destroyed.'
  end

  def shipped
    @order.change_status(:shipped)
    if @order.save
      respond_to do |format|
        OrderNotifier.shipped(@order).deliver
        format.html { redirect_to @order, notice: 'Статус обновлен, сообщение об отправке заказа выслано на почту.' }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def order_params
      params.require(:order).permit(:name, :address, :email, :pay_type, :series, :number, :issue, :tel, :comments, :status)
    end
end