class DiscountsController < ApplicationController
  before_action :find_merchant, only: [:index, :new, :create, :destory, :show, :edit, :update]
  before_action :find_discount, only: [:edit, :update]

  def index
  end

  def new
  end

  def create
    @discount = @merchant.discounts.new(discount_create_params)
    if @discount.save
      require "pry"; binding.pry
      redirect_to merchant_discounts_path(@merchant)
    else
      flash[:error] = "Please use only numbers in the Percent Discount and Quantity fields"
      render :new
    end
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def edit
  end

  def update
    # @discount.update(discount_create_params)
    # require "pry"; binding.pry
    if @discount.update(:percent_discount => params[:discount][:percent_discount], :quantity => params[:discount][:quantity])
      redirect_to merchant_discount_path(@merchant, @discount)
    else
      flash[:error] = "Please use only whole numbers in Percent Discount and Quantity fields"
      render :edit
    end
  end

  def destroy
    Discount.destroy(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
    redirect_to merchant_discounts_path(@merchant)
  end

  private

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def find_discount
    @discount = Discount.find(params[:id])
  end

  def discount_create_params
    params[:percent_discount] = params[:percent_discount].to_i/100.0
    params.permit(:percent_discount, :quantity)
  end
end
